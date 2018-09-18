Rails.application.routes.draw do
  root to: 'teams#index'
  resources :teams, only: [:create, :destroy]
  get '/:slug', to: 'teams#show'
  resources :channels, only: [:show, :create, :destroy]
  resources :talks, only: [:show]
  resources :team_users, only: [:create, :destroy]
  resources :invitations, only: [:create, :destroy, :index, :update]
  mount ActionCable.server => '/cable'
  devise_for :users, :controllers => { registrations: 'registrations' }
end