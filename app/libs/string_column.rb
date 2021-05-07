class StringColumn
  def self.validate(value)
    return if value.is_a?(String)
    "must be String, was actually #{value.class}"
  end
end