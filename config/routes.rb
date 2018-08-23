Rails.application.routes.draw do
  get 'channels/create'

  get 'channels/destroy'

  get 'channels/show'

  devise_for :users, :controllers => { registrations: 'registrations' }
end
