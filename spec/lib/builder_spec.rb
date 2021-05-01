require 'rails_helper'

describe Builder do
  context 'attributeが非Hashのhashが渡された時' do
    it 'インスタンスをbuildする' do
      image = Builder.build(
        type: 'binary_image',
        b64_image: Base64.encode64(file_fixture('builder/input.png').read)
      )

      expect(image.class).to eq BinaryImage
      expect(image.image.signature).to eq MiniMagick::Image.open(file_fixture('builder/input.png')).signature
    end
  end

  context 'attributeがHashのhashが渡された時' do
    it '子インスタンスを持つインスタンスをbuildする' do
      binarization_filter = Builder.build(
        type: 'binarization_filter',
        input_image: {
          type: 'binary_image',
          image: 'some binary image'  
        }
      )

      expect(binarization_filter.class).to eq BinarizationFilter
      expect(binarization_filter.input_image.class).to eq BinaryImage
    end
  end
end