class BinaryImage
  include ImageGeneratable

  column :b64_image, StringColumn

  def image_file_path(tmpdir:)
    out_file = create_tempfile(tmpdir: tmpdir)
    out_file.write Base64.decode64(b64_image)
    out_file.path
  end
end
