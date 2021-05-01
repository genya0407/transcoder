class GrayscaleFilter
  include ImageGeneratable

  column :input_image, ImageGeneratable

  def image
    img = input_image.image
    img.type('Grayscale')
    img
  end
end
