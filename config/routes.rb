Rails.application.routes.draw do
  ActiveAdmin.routes(self)
  namespace :api, {format: 'json'} do
    namespace :v1 do
      resources :company, only: [:index, :show] do
        resources :client, only: [:index, :show] do
          resources :project, only: [:index, :show] do
            resources :sheet, only: [:index, :show]
          end
        end
      end
    end
  end
end
