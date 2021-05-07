class IntegerColumn
  attr_reader :max, :min, :default
  
  def initialize(max: nil, min: nil, default: nil)
    @max = max
    @min = min
    @default = default
  end

  def validate(value)
    return unless value.is_a?(Integer)
    return if (@min || -Float::Infinity) <= value && value <= (@max || Float::Infinity)
    "must be between #{(@min || -Float::Infinity)} and #{(@max || Float::Infinity)}"
  end
end