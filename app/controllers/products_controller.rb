# frozen_string_literal: true

class ProductsController < AuthenticatedController
  def index
    @products = ShopifyAPI::Product.all(limit: 10)
    render(json: { products: @products })
  end

  def transfer
    product_id = params[:product_id]
    target_store = params[:target_store]

    TransferProductJob.perform_later(product_id, target_store, current_shopify_domain)
    render json: { message: "Product transfer initiated." }
  end
end
