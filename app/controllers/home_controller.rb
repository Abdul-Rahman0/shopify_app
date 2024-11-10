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
    end
  end

  def select_store
    @other_stores = Shop.where.not(shopify_domain: current_shopify_domain)
    render json: { stores: @other_stores.pluck(:shopify_domain) }
  end
end
