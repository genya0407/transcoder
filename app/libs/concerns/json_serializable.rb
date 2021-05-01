module JsonSerializable
  extend ActiveSupport::Concern  
  include ActiveModel::Serializers::JSON

  included do
    attr_accessor *columns
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
end