module ImageGeneratable
  extend ActiveSupport::Concern  
  include ActiveModel::Serializers::JSON
  include ActiveModel::Validations

  included do
    validate :validate_columns
    ImageGeneratable.schema << self
    column :gid, String
  end

  module ClassMethods
    def columns
      schema.keys
    end

    def column(name, type)
      schema[name] = type
      attr_accessor name
      validates name, presence: true
    end

    def schema
      @schema ||= {}
    end

    def present_schema
      schema.transform_values(&:name)
    end
  end

  def self.schema
    @schema ||= []
  end

  def self.present_schema
    schema.map(&:name)
  end

  def image_b64
    Tempfile.open(['result', '.png']) do |f|
      image.write(f)
      f.rewind
      Base64.encode64(f.read)
    end
  end

  def all_child_generators
    child_generators = generator_columns
    child_generators.dup.each do |child_generator|
      child_generators.concat(child_generator.all_child_generators)
    end
    child_generators
  end

  def generator_columns
    self.class.schema.select { |_, klass| klass <= ImageGeneratable }.map { |name, _| self.public_send(name) }
  end

  def type
    self.class.name.underscore
  end

  def attributes=(hash)
    hash.with_indifferent_access.slice(*self.class.columns).each do |key, value|
      public_send("#{key}=", value)
    end
  end

  def attributes
    self.class.columns.map do |column|
      [column, public_send(column)]
    end.to_h.merge(
      type: type
    ).with_indifferent_access
  end

  def validate_columns
    self.class.columns.each do |column|
      column_value = self.public_send(column)
      next unless column_value.respond_to?(:valid?)
      next if column_value.valid?

      column_value.errors.each do |error|
        self.errors.add("#{column}.#{error.attribute}", error.message)
      end
    end
  end
end

# 開発時、ImageGeneratableがアンロードされたとしても、ImageGeneratable.schemaが正しく動くようにする
Dir.glob('../*.rb').each do |fname|
  require fname
end
