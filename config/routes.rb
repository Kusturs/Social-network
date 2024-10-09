Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'

  devise_for :profiles,
             path: '',
             path_names: {
               sign_in: 'login',
               sign_out: 'logout',
               registration: 'signup'
             },
             controllers: {
               sessions: 'sessions',
               registrations: 'registrations'
             }

  resources :users, only: %i[index show create update destroy] do
    member do
      post 'follow', to: 'subscriptions#create'
      delete 'unfollow', to: 'subscriptions#destroy'
    end

    collection do
      get :me
    end
  end

  resources :posts, only: %i[index show create update destroy] do
    resources :comments, only: %i[index create]
  end

  resources :comments, only: %i[show update destroy] do
    resources :comments, only: %i[index create], as: 'replies'
  end

  resources :subscriptions, only: %i[index destroy]
end
