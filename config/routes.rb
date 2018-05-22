Rails.application.routes.draw do
  devise_for :users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  root to: 'admin/dashboard#index'

  namespace :api do
    namespace :v1 do
      resources :axes
      resources :activity_types
      resources :curricular_components
      resources :learning_objectives
      resources :sustainable_development_goals
    end
  end
end
