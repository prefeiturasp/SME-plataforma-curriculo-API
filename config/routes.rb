Rails.application.routes.draw do
  devise_for :users, { skip: :omniauth_callbacks }.merge(ActiveAdmin::Devise.config)

  ActiveAdmin.routes(self)

  root to: 'rails/welcome#index'

  namespace :api, defaults: { format: 'json' } do
    mount_devise_token_auth_for 'User',
                                at: 'auth',
                                controllers: {
                                  omniauth_callbacks: 'api/omniauth_callbacks'
                                }

    resources :filters, path: 'filtros', only: [:index]
    resources :activity_sequences, path: 'sequencias', param: :slug, only: %i[index show] do
      get 'atividades/:activity_slug', to: 'activities#show'
      post 'avaliacao', to: 'activity_sequence_ratings#create'
      resources :collections, path: 'colecoes', only: [:index]
    end
    resources :knowledge_matrices, path: 'saberes', only: [:index]
    resources :sustainable_development_goals, path: 'ods', only: %i[index show]
    resources :roadmaps, path: 'roteiros', only: [:index]
    get :perfil, to: 'profiles#me'

    resources :teachers, path: 'professores', only: %i[show create update] do
      post :avatar, action: :avatar
      delete :avatar, action: :avatar_purge
      resources :collections, path: 'colecoes' do
        resources :activity_sequences, path: 'sequencias'
      end
      get :all_collections, path: 'todas_colecoes'
      get 'sequencias_realizadas', to: 'activity_sequence_performeds#index'
      get 'sequencias_realizadas/:activity_sequence_slug/avaliacoes', to: 'activity_sequence_performeds#show_ratings'
    end
    resources :ratings, path: 'avaliacao_criterios', only: [:index]
    resources :activity_sequence_performeds, path: 'sequencias_realizadas', only: [:index]

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

    match '*path', to: 'errors#catch_404', via: :all
  end
end
