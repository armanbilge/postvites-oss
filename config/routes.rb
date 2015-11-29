Rails.application.routes.draw do

  root 'pages#index'

  get '/auth/:provider/callback', to: 'sessions#create'
  delete '/signout', to: 'sessions#destroy', as: 'signout'

  resources :conferences do
    member do
      patch :upload
      patch :import_attendees
      patch :import_presenters
      post :email_presenters
      post :email_attendees
    end
  end

  resources :presenters, path: 'invite', only: [:show, :update], param: :secret

  default_url_options host: ENV['HOSTNAME']

end
