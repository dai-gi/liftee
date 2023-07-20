Rails.application.routes.draw do
  namespace :api, {format: 'json'} do
    namespace :v1 do
      resources :company, only: [:index, :show]
    end
  end
end
