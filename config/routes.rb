Rails.application.routes.draw do
  devise_for :users, ActiveAdmin::Devise.config
  devise_for :users,
              path: 'api',
              skip: %i[sessions registrations passwords],
              controllers: {
               sessions: 'api/sessions'
              },
              path_names: {
                sign_in: 'login',
                sign_out: 'logout'
              }
  ActiveAdmin.routes(self)

  root to: 'rails/welcome#index'

  namespace :api, defaults: { format: 'json' } do
    as :user do
      get :login, to: 'sessions#new', as: :new_jwt_user_session
      post :login, to: 'sessions#create'
      match :logout, to: 'sessions#destroy', as: :destroy_jwt_user_session, via: [:delete, :get]
    end

    resources :answer_books, only:[:index]
    resources :complement_books, only:[:index]
    resources :stages, only:[:index]
    resources :survey_forms, only:[:show]
    resources :survey_form_answers, only: [:new, :create]
    resources :segments, only:[:index]
    resources :years, only:[:index]
    resources :projects, only: [:create, :index, :show, :update], param: :slug do
      get 'projects/:slug', to: 'projects#show'
      resources :collections, path: 'colecoes', only: [:index]
    end
    resources :project_select_options, only: [:index]
    resources :student_protagonisms, only: [:index]
    resources :learning_objectives, only: [:index]
    resources :schools, only: [:index]
    resources :comments, only: [:index, :create, :destroy]
    resources :regional_education_boards, only: [:index]
    resources :filters, path: 'filtros', only: [:index]
    resources :public_consultations
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
      member do
        get '/todas_respostas', action: :all_survey_form_answers_finished
      end
      post :avatar, action: :avatar

      delete :avatar, action: :avatar_purge
      resources :collections, path: 'colecoes' do
        resources :activity_sequences, path: 'sequencias'
        post 'projetos', to: 'projects#save_project'
        get 'projetos', to: 'projects#load_projects'
        delete 'projetos/:id', to: 'projects#delete_project'
      end
      get :my_projects, path: 'meus_projetos'
      get :all_challenges, path: 'favoritos'
      get :all_collections, path: 'todas_colecoes'
      get 'sequencias_realizadas', to: 'activity_sequence_performeds#index'
      get 'sequencias_realizadas/:activity_sequence_slug/avaliacoes', to: 'activity_sequence_ratings#index'
    end
    resources :ratings, path: 'avaliacao_criterios', only: [:index]
    resources :activity_sequence_performeds, path: 'sequencias_realizadas', only: [:index]

    get 'desafios/:state', to: 'challenges#index', constraints: { state: /finalizados|andamento/ }

    resources :challenges, path: 'desafios', param: :slug, only: [:show, :index] do
      resources :results, path: 'resultados', only: [:index, :show, :create]
    end

    resources :methodologies, path: 'metodos', param: :slug, only: [:show, :index]

    namespace :v1 do
      resources :activities
      resources :activity_sequences
      resources :activity_types
      resources :answer_books
      resources :axes
      resources :complement_books
      resources :curricular_components
      resources :learning_objectives
      resources :roadmaps
      resources :segments
      resources :stages
      resources :years
      resources :sustainable_development_goals
      resources :knowledge_matrices
    end

    match '*path', to: 'errors#catch_404', via: :all
  end
end
