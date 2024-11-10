# frozen_string_literal: true

class HomeController < ApplicationController
  include ShopifyApp::EnsureInstalled
  include ShopifyApp::ShopAccessScopesVerification

  def index
    if ShopifyAPI::Context.embedded? && (!params[:embedded].present? || params[:embedded] != "1")
      redirect_to(ShopifyAPI::Auth.embedded_app_url(params[:host]) + request.path, allow_other_host: true)
    else
      @shop_origin = current_shopify_domain
      @host = params[:host]

      # Get other stores and current store products
      @other_stores = Shop.where.not(shopify_domain: @shop_origin)
      @products = ShopifyAPI::Product.all(limit: 10) # Adjust the limit as needed
    end
  end

  def transfer
    product_ids = params[:product_ids]
    target_store = params[:target_store]
  
    if product_ids.is_a?(Array)
      TransferProductJob.perform_later(product_ids, target_store, current_shopify_domain)
    else
      # If only a single product_id is provided, still pass it as an array
      TransferProductJob.perform_later([product_ids], target_store, current_shopify_domain)
    end
  
    redirect_to root_path, notice: "Product transfer initiated."
  end  
end
