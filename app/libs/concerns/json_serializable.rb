module JsonSerializable
  extend ActiveSupport::Concern  
  include ActiveModel::Serializers::JSON
  include ActiveModel::Validations

  included do
    attr_accessor *columns
    columns.each do |column|
      validates column, presence: true
    end
    validate :validate_columns
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