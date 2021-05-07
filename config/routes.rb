Rails.application.routes.draw do
  resources :convert do
    collection do
      post :create_generator
    end
  end
end
