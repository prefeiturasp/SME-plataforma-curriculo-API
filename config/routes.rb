Rails.application.routes.draw do
  devise_for :users, { skip: :omniauth_callbacks }.merge(ActiveAdmin::Devise.config)
  
  ActiveAdmin.routes(self)

  root :to => 'rails/welcome#index'

  namespace :api, defaults: { format: 'json' } do
    mount_devise_token_auth_for 'User',
                                at: 'auth',
                                controllers: {
                                  omniauth_callbacks: 'api/omniauth_callbacks'
                                }

    get 'filtros', to: 'filters#index'
    get 'sequencias', to: 'activity_sequences#index'
    get 'sequencias/:slug', to: 'activity_sequences#show'
    get 'sequencias/:activity_sequence_slug/atividades/:activity_slug', to: 'activities#show'
    get 'saberes', to: 'knowledge_matrices#index'
    get 'ods', to: 'sustainable_development_goals#index'
    get 'ods/:id', to: 'sustainable_development_goals#show'
    get 'roteiros', to: 'roadmaps#index'

    resources :teachers, path: 'professores', only: [:show, :create, :update] do
      post :avatar, action: :avatar
      resources :collections, path: 'colecoes'
    end

    namespace :v1 do
      resources :activities
      resources :activity_sequences
      resources :activity_types
      resources :axes
      resources :curricular_components
      resources :learning_objectives
      resources :roadmaps
      resources :sustainable_development_goals
      resources :knowledge_matrices
    end

    match "*path", to: "errors#catch_404", via: :all
  end
end
