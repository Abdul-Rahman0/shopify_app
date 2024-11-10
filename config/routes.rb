Rails.application.routes.draw do
  root 'home#index'

  get '/products', to: 'products#index'
  post '/products/transfer', to: 'products#transfer'
  get '/select_store', to: 'home#select_store'

  mount ShopifyApp::Engine, at: '/'
end
