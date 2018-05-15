Rails.application.routes.draw do
  devise_for :users
  ActiveAdmin.routes(self)

  namespace :api do
    namespace :v1 do
      resources :activity_types
    end
  end
end
