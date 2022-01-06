Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get 'ping', to: 'ping#index'
      get 'posts', to: 'posts#index'
    end
  end
end
