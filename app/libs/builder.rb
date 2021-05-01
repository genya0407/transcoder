module Builder
  # 以下のようなhashを想定
  <<~HASH
  {
    "type": "binalization_filter",
    "input": {
      "type": "binary_image",
      "image": "base64 encoded image binary"
    }
  }
  HASH
  module_function def build(hash)
    image_instance = hash.fetch(:type).camelize.constantize.new
    attributes = hash.except(:type).map do |key, value|
      attribute = if value.is_a?(Hash)
                    build(value)
                  else
                    value
                  end
      [key, attribute]
    end.to_h
    image_instance.attributes = attributes
    image_instance
  end
end