class BinarizationFilter
  include ImageGeneratable

  column :input_image, ImageGeneratable
  column :threshold, Integer

  def image
    img = input_image.image
    img.threshold("#{threshold}%")
    img
  end
end
