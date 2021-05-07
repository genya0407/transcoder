class GrayscaleFilter
  include ImageGeneratable

  column :input_image, ImageGeneratable

  def image_file_path(tmpdir:)
    out_file = create_tempfile(basename: ['result', 'png'], tmpdir: tmpdir)
    img = MiniMagick::Image.open(input_image.image_file_path(tmpdir: tmpdir))
    img.type('Grayscale')
    img.write(out_file)
    out_file.path
  end
end
