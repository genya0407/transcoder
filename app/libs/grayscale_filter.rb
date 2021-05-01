class GrayscaleFilter
  def self.columns; %i[input_image]; end

  include JsonSerializable

  def image
    img = input_image.image
    img.type('Grayscale')
    img
  end
end
