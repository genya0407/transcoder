require 'rails_helper'

describe BinarizationFilter do
  describe '#image' do
    let(:threshold_percent) { 80 }
    let(:binary_image) do
      BinaryImage.new.tap do |img|
        img.attributes = { b64_image: Base64.encode64(file_fixture('binarization_filter/input.png').read) }
      end
    end
    let(:binarization_filter) do
      BinarizationFilter.new.tap do |img|
        img.attributes = { input_image: binary_image, threshold_percent: threshold_percent }
      end
    end
    let(:output_image) { MiniMagick::Image.open(file_fixture('binarization_filter/output.png')) }
    
    it 'input_imageをthresholdで2値化する' do
      Dir.mktmpdir do |tmpdir|
        expect(MiniMagick::Image.open(binarization_filter.image_file_path(tmpdir: tmpdir)).signature).to eq output_image.signature
      end
    end
  end
end
