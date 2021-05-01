module ImageHelper
  def read_mimemagick_image(fixture_path)
    MiniMagick::Image.open(file_fixture(fixture_path))
  end

  def read_binary_image(fixture_path)
    BinaryImage.new.tap do |img|
      img.attributes = { b64_image: Base64.encode64(file_fixture(fixture_path).read) }
    end
  end
end