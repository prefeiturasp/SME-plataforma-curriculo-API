Rails.application.routes.draw do
  devise_for :users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  root to: 'admin/dashboard#index'

  namespace :api, defaults: { format: 'json' } do
    get 'filtros', to: 'filters#index'
    get 'sequencias', to: 'activity_sequences#index'
    get 'sequencias/:slug', to: 'activity_sequences#show'
    get 'sequencias/:activity_sequence_slug/atividades/:activity_slug', to: 'activities#show'
    get 'saberes', to: 'knowledge_matrices#index'

    namespace :v1 do
      resources :activities
      resources :activity_sequences
      resources :activity_types
      resources :axes
      resources :curricular_components
      resources :learning_objectives
      resources :sustainable_development_goals
      resources :knowledge_matrices
    end

    match "*path", to: "errors#catch_404", via: :all
  end
end
