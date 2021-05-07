class BinarizationFilter
  include ImageGeneratable

  column :input_image, ImageGeneratable
  column :threshold_percent, IntegerColumn.new(max: 100, min: 0, default: 50)

  def image_file_path(tmpdir:)
    out_file = create_tempfile(basename: ['result', 'png'], tmpdir: tmpdir) 
    img = MiniMagick::Image.open(input_image.image_file_path(tmpdir: tmpdir))
    img.threshold("#{threshold_percent}%")
    img.write(out_file)
    out_file.path
  end
end
