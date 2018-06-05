Rails.application.routes.draw do
  devise_for :users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  root to: 'admin/dashboard#index'

  namespace :api do
    get 'filtros/sequencia_atividade', to: 'filters#activity_sequence_index'
    get 'filtros/sequencia_atividade/ano/:year', to: 'filters#activity_sequece_index_filter'
    get 'filtros/sequencia_atividade/ano/:year/componente/:curricular_component_friendly_id', to: 'filters#activity_sequece_index_filter'


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
  end
end
