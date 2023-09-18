Rails.application.routes.draw do
  ActiveAdmin.routes(self)
  namespace :api, {format: 'json'} do
    namespace :v1 do
      resources :company, only: [:index, :show]
      resources :client, only: [:index, :show]
      resources :project, only: [:index, :show]
      resources :sheet, only: [:index, :show, :create, :destroy, :update]
      resources :task, only: [:index, :show, :create, :destroy, :update]
    end
  end
end

