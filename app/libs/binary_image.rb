class BinaryImage
  def self.columns; %i[b64_image]; end

  include JsonSerializable

  def image
    MiniMagick::Image.read(Base64.decode64(b64_image))
  end
end
