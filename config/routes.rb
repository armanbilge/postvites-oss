Rails.application.routes.draw do

  root 'pages#index'

  get '/contact', to: 'pages#contact'
  post '/contact', to: 'pages#send_message'

  get '/ping', to: 'pages#ping'

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

  resources :presenters, path: 'invite', only: [:show, :update], param: :secret do
    member do
      get :mobile
      post :page
    end
  end

  get '/invitations/:presenter_secret/:attendee_id', to: 'invitations#show'
  patch '/invitations/:presenter_secret/:attendee_id', to: 'invitations#update'
  get '/invitations/:presenter_secret/:attendee_id/json', to: 'invitations#json'
  delete '/invitations/:presenter_secret/:attendee_id', to: 'invitations#destroy'

  default_url_options host: ENV['HOST']

end
