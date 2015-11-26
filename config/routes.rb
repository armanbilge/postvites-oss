Rails.application.routes.draw do

  root 'pages#index'

  get '/auth/:provider/callback', to: 'sessions#create'
  delete '/signout', to: 'sessions#destroy', as: 'signout'

  resources :conferences do
    member do
      patch :upload
      patch :import_attendees
      patch :import_presenters
    end
  end

  resources :presenters, path: 'invite', only: [:show, :edit], param: :secret

end
