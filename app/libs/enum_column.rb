class EnumColumn
  attr_reader :values

  def initialize(*values)
    @values = values
  end

  def validate(value)
    return if @values.include?(value)
    "must be one of #{@values.inspect}"
  end
end