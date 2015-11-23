Rails.application.routes.draw do

  root 'pages#index'

  get '/auth/:provider/callback', to: 'sessions#create'
  get '/signout', to: 'sessions#destroy', as: 'signout'

  resources :conferences
  patch '/conferences/:id/upload', to: 'conferences#upload'
  patch '/conferences/:id/import_attendees', to: 'conferences#import_attendees'
  patch '/conferences/:id/import_presenters', to: 'conferences#import_presenters'

end
