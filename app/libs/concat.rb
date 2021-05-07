class Concat
  include ImageGeneratable
  
  column :direction, EnumColumn.new('horizontal', 'vertical')
  column :input_image_1, ImageGeneratable
  column :input_image_2, ImageGeneratable

  def image_file_path(tmpdir:)
    base_img_path = input_image_1.image_file_path(tmpdir: tmpdir)
    additional_image_file = scaled_additonal_image_path(tmpdir: tmpdir)
    out_file = create_tempfile(basename: ['result', 'png'], tmpdir: tmpdir)
    MiniMagick::Tool::Convert.new do |convert|
      if direction == 'horizontal'
        convert.append.+
      else
        convert.append
      end
      convert << base_img_path
      convert << additional_image_file
      convert << out_file.path
    end
    out_file.path
  end

  private
  def scaled_additonal_image_path(tmpdir:)
    base_img = MiniMagick::Image.open(input_image_1.image_file_path(tmpdir: tmpdir))
    additional_img = MiniMagick::Image.open(input_image_2.image_file_path(tmpdir: tmpdir))
    if direction == 'horizontal'
      base_height = base_img.height
      additional_img.geometry("x#{base_height}")
    else
      base_width = base_img.width
      additional_img.geometry("#{base_width}x")
    end
    additional_tmp_image_file = create_tempfile(basename: ['reesult', 'png'], tmpdir: tmpdir)
    additional_img.write additional_tmp_image_file
    additional_tmp_image_file.path
  end
end
