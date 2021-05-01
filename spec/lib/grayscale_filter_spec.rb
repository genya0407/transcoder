require 'rails_helper'

describe GrayscaleFilter do
  describe '#image' do
    let(:grayscale_filter) do
      GrayscaleFilter.new.tap do |img|
        img.attributes = {
          input_image: read_binary_image('grayscale_filter/input.png'),
        }
      end
    end
    let(:output_image) { read_mimemagick_image('grayscale_filter/output.png') }
    
    it 'input_imageをthresholdで2値化する' do
      expect(grayscale_filter.image.signature).to eq output_image.signature
    end
  end
end
