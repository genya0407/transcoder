class ConvertController < ApplicationController
  def index
    BinarizationFilter
    GrayscaleFilter
    BinaryImage
  end

  def create
    generators_hash = params.require(:generators).permit!.to_h.with_indifferent_access
    recipes = construct_hash(generators_hash: generators_hash)
    generators = recipes.map { |recipe| Builder.build(recipe) }
    if generators.all?(&:invalid?)
      render json: { errors: generators.map(&:errors).flatten }, status: 422
      return
    end
    @valid_generators = generators.select(&:valid?)

    respond_to do |format|
      format.turbo_stream
    end
  end

  def create_generator
    generator_type = params[:generator_type]
    BinarizationFilter
    GrayscaleFilter
    BinaryImage
    raise ActionController::RoutingError.new('Not Found') unless ImageGeneratable.schema.map(&:name).map(&:underscore).any? { |klass_name| klass_name == generator_type }

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.append(:generators, partial: generator_type, locals: { generator_id: generate_generator_id })
      end
    end  
  end

  # 10回引く試行をやったとき、重複のある確率が1億回に1回
  # N通りから100回復元抽出をする。全部異なる確率は、N_P_10 / n^10
  # １つでも重複する確率は 1 - N_P_10 / N^10
  # つまり 1 - N_P_10 / N^10 < 1/1億
  # 1 - 1/1億 < N_P_10 / N^10

  private
  # TODO: なんか怪しい挙動をしそうな気がするので後でちゃんと考える
  def construct_hash(generators_hash:)
    generators_hash = generators_hash.deep_dup
    generators_hash.keys.to_a.each do |target_gid|
      next unless generators_hash[target_gid]
      target_generator = generators_hash.delete(target_gid)
      target_generator[:gid] = target_gid
      replace_suceed = replace_gid_by_value(target: target_generator, generators_hash: generators_hash)
      generators_hash[target_gid] = target_generator if replace_suceed
    end
    generators_hash.values
  end

  def replace_gid_by_value(target:, generators_hash:)
    image_generatable_columns = target.fetch(:type).classify.constantize.schema.to_a.select { |_, klass| klass <= (ImageGeneratable) }.map(&:first)
    image_generatable_columns.each do |column|
      gid = target[column]
      return false unless generators_hash[gid]
      target[column] = generators_hash.delete(gid)
      target[column][:gid] = gid
      replace_gid_by_value(target: target[column], generators_hash: generators_hash)
    end
  end

  helper_method def generate_generator_id
    # 10回生成する試行を行い、重複がない確率が1/1億以下となるようにしている
    SecureRandom.hex(3)
  end
end
