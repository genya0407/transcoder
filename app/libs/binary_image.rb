class BinaryImage
  include ImageGeneratable

  column :b64_image, String

  def image
    MiniMagick::Image.read(Base64.decode64(b64_image))
  end
end
