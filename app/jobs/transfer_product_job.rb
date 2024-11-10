# frozen_string_literal: true

class TransferProductJob < ApplicationJob
  queue_as :default

  def perform(product_id, target_store, source_store)
    # Set up sessions for the source and target stores
    source_shop = Shop.find_by(shopify_domain: source_store)
    target_shop = Shop.find_by(shopify_domain: target_store)

    return unless source_shop && target_shop

    source_shop.with_shopify_session do
      product = ShopifyAPI::Product.find(product_id)

      # Transfer product data to the target store
      target_shop.with_shopify_session do
        ShopifyAPI::Product.create(
          title: product.title,
          body_html: product.body_html,
          vendor: product.vendor,
          product_type: product.product_type,
          variants: product.variants.map { |variant| { price: variant.price, sku: variant.sku } }
        )
      end
    end
  end
end
