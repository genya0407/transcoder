Rails.application.routes.draw do
  resources :convert do
    collection do
      get :schema
    end
  end
end
