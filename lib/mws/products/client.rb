# frozen_string_literal: true

require 'peddler/client'

module MWS
  module Products
    # The MWS Products API helps you get information to match your products to
    # existing product listings on Amazon Marketplace websites and to make
    # sourcing and pricing decisions for listing those products on Amazon
    # Marketplace websites.
    class Client < ::Peddler::Client
      version '2011-10-01'
      path "/Products/#{version}"

      # Lists products and their attributes, based on a search query
      #
      # @see https://docs.developer.amazonservices.com/en_US/products/Products_ListMatchingProducts.html
      # @overload list_matching_products(query, opts = { marketplace_id:
      #   primary_marketplace_id })
      #   @param [String] query
      #   @param [Hash] opts
      #   @option opts [String] :marketplace_id
      #   @option opts [String] :query_context_id
      # @return [Peddler::XMLParser]
      def list_matching_products(query, opts = {})
        operation_with_marketplace('ListMatchingProducts')
          .add(opts.update('Query' => query))

        run
      end

      # Lists products and their attributes, based on a list of ASIN, GCID,
      #   SellerSKU, UPC, EAN, ISBN, and JAN values
      #
      # @see https://docs.developer.amazonservices.com/en_US/products/Products_GetMatchingProduct.html
      # @overload get_matching_product_for_id(id_type, *ids, opts = {
      #   marketplace_id: primary_marketplace_id })
      #   @param [String] id_type
      #   @param [String] id one or more ids
      #   @param [Hash] opts
      #   @option opts [String] :marketplace_id
      # @return [Peddler::XMLParser]
      def get_matching_product_for_id(id_type, *id_list)
        opts = extract_options(id_list)

        operation_with_marketplace('GetMatchingProductForId')
          .add(opts.update('IdType' => id_type, 'IdList' => id_list))
          .structure!('IdList', 'Id')

        run
      end

      # Lists products and their attributes, based on a list of ASIN values
      #
      # @see https://docs.developer.amazonservices.com/en_US/products/Products_GetMatchingProductForId.html
      # @overload get_matching_product(*asins, opts = { marketplace_id:
      #   primary_marketplace_id })
      #   @param [String] asin one or more asins
      #   @param [Hash] opts
      #   @option opts [String] :marketplace_id
      # @return [Peddler::XMLParser]
      def get_matching_product(*asin_list)
        opts = extract_options(asin_list)

        operation_with_marketplace('GetMatchingProduct')
          .add(opts.update('ASINList' => asin_list))
          .structure!('ASINList', 'ASIN')

        run
      end

      # Gets the current competitive price of a product, based on Seller SKU
      #
      # @see https://docs.developer.amazonservices.com/en_US/products/Products_GetCompetitivePricingForSKU.html
      # @overload get_competitive_pricing_for_sku(*seller_skus, opts = {
      #   marketplace_id: primary_marketplace_id })
      #   @param [String] seller_sku one or more seller_skus
      #   @param [Hash] opts
      #   @option opts [String] :marketplace_id
      # @return [Peddler::XMLParser]
      def get_competitive_pricing_for_sku(*seller_sku_list)
        opts = extract_options(seller_sku_list)

        operation_with_marketplace('GetCompetitivePricingForSKU')
          .add(opts.update('SellerSKUList' => seller_sku_list))
          .structure!('SellerSKUList', 'SellerSKU')

        run
      end

      # Gets the current competitive price of a product, identified by its ASIN
      #
      # @see https://docs.developer.amazonservices.com/en_US/products/Products_GetCompetitivePricingForASIN.html
      # @overload get_competitive_pricing_for_asin(*asins, opts = {
      #   marketplace_id: primary_marketplace_id })
      #   @param [String] asin one or more asins
      #   @param [Hash] opts
      #   @option opts [String] :marketplace_id
      # @return [Peddler::XMLParser]
      def get_competitive_pricing_for_asin(*asin_list)
        opts = extract_options(asin_list)

        operation_with_marketplace('GetCompetitivePricingForASIN')
          .add(opts.update('ASINList' => asin_list))
          .structure!('ASINList', 'ASIN')

        run
      end

      # Gets pricing information for the lowest-price active offer listings for
      # a product, based on Seller SKU
      #
      # @see https://docs.developer.amazonservices.com/en_US/products/Products_GetLowestOfferListingsForSKU.html
      # @overload get_lowest_offer_listings_for_sku(*seller_skus, opts = {
      #   marketplace_id: primary_marketplace_id })
      #   @param [String] seller_sku one or more seller_skus
      #   @param [Hash] opts
      #   @option opts [String] :marketplace_id
      #   @option opts [String] :item_condition
      #   @option opts [Boolean] :exclude_me
      # @return [Peddler::XMLParser]
      def get_lowest_offer_listings_for_sku(*seller_sku_list)
        opts = extract_options(seller_sku_list)

        operation_with_marketplace('GetLowestOfferListingsForSKU')
          .add(opts.update('SellerSKUList' => seller_sku_list))
          .structure!('SellerSKUList', 'SellerSKU')

        run
      end

      # Gets pricing information for the lowest-price active offer listings for
      # a product, identified by its ASIN
      #
      # @see https://docs.developer.amazonservices.com/en_US/products/Products_GetLowestOfferListingsForASIN.html
      # @overload get_lowest_offer_listings_for_asin(*asins, opts = {
      #   marketplace_id: primary_marketplace_id })
      #   @param [String] asin one or more asins
      #   @param [Hash] opts
      #   @option opts [String] :marketplace_id
      #   @option opts [String] :item_condition
      #   @option opts [Boolean] :exclude_me
      # @return [Peddler::XMLParser]
      def get_lowest_offer_listings_for_asin(*asin_list)
        opts = extract_options(asin_list)

        operation_with_marketplace('GetLowestOfferListingsForASIN')
          .add(opts.update('ASINList' => asin_list))
          .structure!('ASINList', 'ASIN')

        run
      end

      # Gets lowest priced offers for a single product, based on SellerSKU
      #
      # @see https://docs.developer.amazonservices.com/en_MX/products/Products_GetLowestPricedOffersForSKU.html
      # @overload get_lowest_priced_offers_for_sku(seller_sku, item_condition,
      #   opts = { marketplace_id: primary_marketplace_id })
      #   @param [String] seller_sku
      #   @param [String] item_condition
      #   @param [Hash] opts
      #   @option opts [String] :marketplace_id
      # @return [Peddler::XMLParser]
      def get_lowest_priced_offers_for_sku(seller_sku, item_condition,
                                           opts = {})
        opts.update(
          'SellerSKU' => seller_sku,
          'ItemCondition' => item_condition
        )
        operation_with_marketplace('GetLowestPricedOffersForSKU')
          .add(opts)

        run
      end

      # Gets lowest priced offers for a single product, based on ASIN
      #
      # @see https://docs.developer.amazonservices.com/en_MX/products/Products_GetLowestPricedOffersForASIN.html
      # @overload get_lowest_priced_offers_for_asin(asin, item_condition, opts =
      #   { marketplace_id: primary_marketplace_id })
      #   @param [String] asin
      #   @param [String] item_condition
      #   @param [Hash] opts
      #   @option opts [String] :marketplace_id
      # @return [Peddler::XMLParser]
      def get_lowest_priced_offers_for_asin(asin, item_condition, opts = {})
        opts.update(
          'ASIN' => asin,
          'ItemCondition' => item_condition
        )
        operation_with_marketplace('GetLowestPricedOffersForASIN')
          .add(opts)

        run
      end

      # Gets the estimated fees for a list of products.
      #
      # @see https://docs.developer.amazonservices.com/en_US/products/Products_GetMyFeesEstimate.html
      # @see https://docs.developer.amazonservices.com/en_US/products/Products_Datatypes.html#FeesEstimateRequest
      # @param [Hash] fees_estimate_request one or more fees estimate requests
      # @return [Peddler::XMLParser]
      def get_my_fees_estimate(*fees_estimate_requests)
        operation('GetMyFeesEstimate')
          .add('FeesEstimateRequestList' => fees_estimate_requests)
          .structure!('FeesEstimateRequestList', 'FeesEstimateRequest')

        run
      end

      # Gets pricing information for seller's own offer listings, based on
      # Seller SKU
      #
      # @see https://docs.developer.amazonservices.com/en_US/products/Products_GetMyPriceForSKU.html
      # @overload get_my_price_for_sku(*seller_skus, opts = { marketplace_id:
      #   primary_marketplace_id })
      #   @param [String] seller_sku one or more seller_skus
      #   @param [Hash] opts
      #   @option opts [String] :marketplace_id
      #   @option opts [String] :item_condition
      # @return [Peddler::XMLParser]
      def get_my_price_for_sku(*seller_sku_list)
        opts = extract_options(seller_sku_list)

        operation_with_marketplace('GetMyPriceForSKU')
          .add(opts.update('SellerSKUList' => seller_sku_list))
          .structure!('SellerSKUList', 'SellerSKU')

        run
      end

      # Gets pricing information for seller's own offer listings, identified by
      # its ASIN
      #
      # @see https://docs.developer.amazonservices.com/en_US/products/Products_GetMyPriceForASIN.html
      # @overload get_my_price_for_asin(*asins, opts = { marketplace_id:
      #   primary_marketplace_id })
      #   @param [String] asin one or more asins
      #   @param [Hash] opts
      #   @option opts [String] :marketplace_id
      #   @option opts [String] :item_condition
      # @return [Peddler::XMLParser]
      def get_my_price_for_asin(*asin_list)
        opts = extract_options(asin_list)

        operation_with_marketplace('GetMyPriceForASIN')
          .add(opts.update('ASINList' => asin_list))
          .structure!('ASINList', 'ASIN')

        run
      end

      # Gets parent product categories that a product belongs to, based on
      # Seller`SKU
      #
      # @see https://docs.developer.amazonservices.com/en_US/products/Products_GetProductCategoriesForSKU.html
      # @overload get_product_categories_for_sku(sku, opts = { marketplace_id:
      #   primary_marketplace_id })
      #   @param [String] seller_sku
      #   @param [Hash] opts
      #   @option opts [String] :marketplace_id
      # @return [Peddler::XMLParser]
      def get_product_categories_for_sku(seller_sku, opts = {})
        operation_with_marketplace('GetProductCategoriesForSKU')
          .add(opts.update('SellerSKU' => seller_sku))

        run
      end

      # Gets parent product categories that a product belongs to, based on ASIN
      #
      # @see https://docs.developer.amazonservices.com/en_US/products/Products_GetProductCategoriesForASIN.html
      # @overload get_product_categories_for_asin(asin, opts = { marketplace_id:
      #   primary_marketplace_id })
      #   @param [String] asin
      #   @param [Hash] opts
      #   @option opts [String] :marketplace_id
      # @return [Peddler::XMLParser]
      def get_product_categories_for_asin(asin, opts = {})
        operation_with_marketplace('GetProductCategoriesForASIN')
          .add(opts.update('ASIN' => asin))

        run
      end

      # Gets the service status of the API
      #
      # @see https://docs.developer.amazonservices.com/en_US/products/Products_GetServiceStatus.html
      # @return [Peddler::XMLParser]
      def get_service_status
        operation('GetServiceStatus')
        run
      end

      # @api private
      def operation_with_marketplace(action)
        operation(action).tap do |opts|
          opts.store('MarketplaceId', primary_marketplace_id)
        end
      end
    end
  end
end
