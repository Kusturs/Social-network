Rails.application.routes.draw do
  get 'up' => 'rails/health#show', as: :rails_health_check

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
               sessions: 'profiles/sessions',
               registrations: 'profiles/registrations'
             }

  resources :users, only: %i[index show]

  resources :feed, only: %i[index]

  resources :posts, only: %i[index show create update destroy] do
    resources :comments, only: %i[index create]
  end

  resources :comments

  resources :subscriptions, only: %i[create destroy]
end
