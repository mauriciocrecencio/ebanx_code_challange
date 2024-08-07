Rails.application.routes.draw do
  post '/reset', to: 'events#reset'
  get '/balance', to: 'accounts#balance'
  post '/event', to: 'events#create'
  post '/accounts/create', to: 'accounts#create'
end