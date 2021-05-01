require 'rails_helper'

describe BinarizationFilter do
  describe '#image' do
    let(:threshold) { '80%' }
    let(:binary_image) do
      BinaryImage.new.tap do |img|
        img.attributes = { b64_image: Base64.encode64(file_fixture('binarization_filter/input.png').read) }
      end
    end
    let(:binarization_filter) do
      BinarizationFilter.new.tap do |img|
        img.attributes = { input_image: binary_image, threshold: threshold }
      end
    end
    let(:output_image) { MiniMagick::Image.open(file_fixture('binarization_filter/output.png')) }
    
    it 'input_imageをthresholdで2値化する' do
      expect(binarization_filter.image.signature).to eq output_image.signature
    end
  end
end
