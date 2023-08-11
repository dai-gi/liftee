Rails.application.routes.draw do
  ActiveAdmin.routes(self)
  namespace :api, {format: 'json'} do
    namespace :v1 do
      resources :company, only: [:index, :show]
      resources :client, only: [:index, :show]
    end
  end
end
