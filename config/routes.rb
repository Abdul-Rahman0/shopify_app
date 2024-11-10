Rails.application.routes.draw do
  root 'home#index'

  post '/transfer_product', to: 'home#transfer', as: 'transfer_product'

  mount ShopifyApp::Engine, at: '/'
end
