Rails.application.routes.draw do
  devise_for :users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  root to: 'admin/dashboard#index'

  namespace :api, defaults: { format: 'json' } do
    get 'filtros/sequencia_atividade', to: 'filters#activity_sequence_index'
    get 'filtros/sequencia_atividade/ano/:year', to: 'filters#activity_sequence_index_filter'
    get 'filtros/sequencia_atividade/ano/:year/componente/:curricular_component_friendly_id', to: 'filters#activity_sequence_index_filter'
    
    get 'sequencias', to: 'activity_sequences#index'


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
