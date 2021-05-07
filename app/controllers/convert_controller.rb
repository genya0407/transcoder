class ConvertController < ApplicationController
  class InvalidGraphError < StandardError; end

  around_action :with_tmpdir

  def index
    # 開発時、ImageGeneratableがアンロードされたとしても、ImageGeneratable.schemaが正しく動くようにする
    Dir.glob('app/libs/*.rb').each do |fname|
      require File.basename(fname)
    end
  end

  def create
    generators_hash = params.require(:generators).permit!.to_h.with_indifferent_access
    check_circular_dependency!(generators_hash: generators_hash)
    recipes = transform_into_recipes(generators_hash: generators_hash)
    @generators = recipes.map { |recipe| Builder.build(recipe) }

    respond_to do |format|
      format.turbo_stream
    end
  end

  def create_generator
    generator_type_string = params[:generator_type]
    generator_type = ImageGeneratable.schema.find { |klass| klass.name.underscore == generator_type_string }
    raise ActionController::RoutingError.new('Not Found') unless generator_type

    respond_to do |format|
      format.turbo_stream do
        partial = case
                  when generator_type == BinaryImage
                    'binary_image'
                  else
                    'generic_generator'
                  end

        render turbo_stream: turbo_stream.append(:generators, partial: partial, locals: { generator_type: generator_type, generator_id: generate_generator_id })
      end
    end
  end

  private
  def check_circular_dependency!(generators_hash:)
    # do nothing
  end
  
  def transform_into_recipes(generators_hash:)
    generators_hash = generators_hash.deep_dup
    generators_hash.values.each do |target|
      gid_columns = target.fetch(:type).classify.constantize.schema.to_a.select { |_, column_type| column_type.is_a?(Module) && column_type <= (ImageGeneratable) }.map(&:first)
      gid_columns.each do |gid_column|
        gid = target[gid_column]
        next unless gid
  
        pointing_generator_hash = generators_hash[gid]
        next unless pointing_generator_hash
  
        target[gid_column] = pointing_generator_hash
      end  
    end
    generators_hash.values
  end

  def with_tmpdir
    Dir.mktmpdir do |tmpdir|
      @tmpdir = tmpdir
      yield
    end
  end

  helper_method def generate_generator_id
    # 10回生成する試行を行い、重複がない確率が1/1億以下となるようにしている
    SecureRandom.hex(3)
  end
end
