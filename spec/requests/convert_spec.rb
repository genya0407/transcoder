require 'rails_helper'

RSpec.describe "Convert", type: :request do
  describe "POST /convert" do
    context 'validなJSONを送信した時' do
      let(:request_body) do
        JSON.generate(
          {
            "type": "binarization_filter",
            "threshold": "80%",
            "input_image": {
              "type": "binary_image",
              "b64_image": Base64.encode64(file_fixture('requests/converts/input.png').read)
            }
          }
        )
      end
      
      it 'JSONが評価され、画像を取得する' do
        post '/convert', params: nil, headers: nil, env: { 'RAW_POST_DATA' => request_body }

        expect(response.status).to eq 200
      end
    end
  end
end
