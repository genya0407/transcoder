require 'rails_helper'

describe Concat do
  describe '#image_file_path' do
    let(:input_image_1) do
      dbl = double(BinaryImage)
      allow(dbl).to receive(:image_file_path).and_return(file_fixture('concat/input_1.png'))
      dbl
    end
    let(:input_image_2) do
      dbl = double(BinaryImage)
      allow(dbl).to receive(:image_file_path).and_return(file_fixture('concat/input_2.png'))
      dbl
    end
    let(:concat) do
      Concat.new.tap do |img|
        img.attributes = { direction: direction, input_image_1: input_image_1, input_image_2: input_image_2 }
      end
    end

    context 'vertical' do
      let(:direction) { 'vertical' }
      let(:output_image) { MiniMagick::Image.open(file_fixture('concat/output_vertical.png')) }

      it '画像を縦方向に連結する' do
        Dir.mktmpdir do |tmpdir|
          expect(MiniMagick::Image.open(concat.image_file_path(tmpdir: tmpdir)).signature).to eq output_image.signature
        end
      end
    end

    context 'horizontal' do
      let(:direction) { 'horizontal' }
      let(:output_image) { MiniMagick::Image.open(file_fixture('concat/output_horizontal.png')) }

      it '画像を横方向に連結する' do
        Dir.mktmpdir do |tmpdir|
          expect(MiniMagick::Image.open(concat.image_file_path(tmpdir: tmpdir)).signature).to eq output_image.signature
        end
      end
    end
  end
end
