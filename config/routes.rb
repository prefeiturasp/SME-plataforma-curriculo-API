Rails.application.routes.draw do
  get 'file_uploads/new'
  devise_for :users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  root to: 'admin/dashboard#index'

  namespace :api do
    namespace :v1 do
      resources :activities do
        resources :file_uploads, only: [:create]
      end
      resources :activity_sequences
      resources :activity_types
      resources :axes
      resources :curricular_components
      resources :learning_objectives
      resources :sustainable_development_goals
      resources :knowledge_matrices
    end
  end
end
