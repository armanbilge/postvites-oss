Rails.application.routes.draw do

  root 'pages#index'

  get '/contact', to: 'pages#contact'
  post '/contact', to: 'pages#send_message'

  get '/auth/:provider/callback', to: 'sessions#create'
  delete '/signout', to: 'sessions#destroy', as: 'signout'

  get '/jobs/:id/:conference', to: 'delayed_jobs#show'

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

  get '/invitations/:presenter_id/:attendee_id', to: 'invitations#show'
  patch '/invitations/:presenter_id/:attendee_id', to: 'invitations#update'

  default_url_options host: ENV['HOST']

end
