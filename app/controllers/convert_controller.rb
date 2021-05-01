class ConvertController < ApplicationController
  def index
  end
  
  def create
    image_filter = Builder.build(JSON.parse(request.body.read, symbolize_names: true))
    unless image_filter.valid?
      render json: { errors: image_filter.errors }, status: 422
      return
    end

    result_image_b64 = Tempfile.open(['result', '.png']) do |f|
      image_filter.image.write(f)
      f.rewind
      Base64.encode64(f.read)
    end

    render json: { result_image_b64: result_image_b64 }
  end
end
