class BinarizationFilter
  def self.columns; %i[input_image threshold]; end

  include JsonSerializable

  def image
    img = input_image.image
    img.threshold(threshold)
    img
  end
end
