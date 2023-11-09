@Sanity
Feature: Checkout without Variant product + Cart Value coupon Applicable

  Scenario: CART_VALUE_COUPON Coupon Applied to Cart With Non Variant Item
    * def product  = call read('classpath:karate/core/pim/pim.feature@ForNonVariantItem') {ItemId : '#(non_variant_itemId)'}
    * def ItemAttributes = product.response.products[0].attributes
    * def ItemId = product.response.products[0].itemId
    * def price  = call read('classpath:karate/core/price/price.feature@PriceForSingleItems') {ItemId: '#(ItemId)'}
    * def sku = product.response.products[0].sku

    * def inventoryForItem  = call read('classpath:karate/core/inventory/inventory.feature@InventoryConfiguredItem') {sku : '#(sku)'}
    * def inventoryChannelForItem1 = inventoryForItem.response.inventory[0].channelId
    * def cart = call read('classpath:karate/core/cart/addToCart.feature@AddingSingleItemToCart') {ItemId: '#(ItemId)', ItemAttributes:'#(ItemAttributes)',InventoryChannelForItem1: '#(inventoryChannelForItem1)'}
    * def cartId = cart.response.cartId
    * def applyCoupon = call read('classpath:karate/core/cart/applyCoupon.feature@SingleLineItem') {cartId: '#(cartId)', couponCode : '#(CART_VALUE_COUPON)'}

    * def shippingDetails = call read('classpath:karate/core/oms/GetShippingByID.feature') {shippingId: '#(shipMethodId)'}
    * def shippingId = shippingDetails.response.shippingMethodId
    * def shippingCost = shippingDetails.response.cost

    * def createShipTo = call read('classpath:karate/core/cart/createShipTo.feature@WEB_SHIP') {cartId: '#(cartId)', shippingMethodId: '#(shippingId)', shippingCost: '#(shippingCost)' }

    * def shipToId = createShipTo.response.shipToId

    * def addShipToCart = call read('classpath:karate/core/cart/addShippingToCart.feature@SingleLineItem') {cartId: '#(cartId)', shipToId: '#(shipToId)', ItemId: '#(ItemId)'}

    * def cartAmount = applyCoupon.response.totalAmount

    * def checkout = call read('classpath:karate/core/checkout/checkout.feature@CheckoutSingleLineItem') {cartId: '#(cartId)', shipToId: '#(shipToId)', shippingCost: '#(shippingCost)', cartTotal: '#(cartAmount)'}
    * def orderId = checkout.response.orderId
    * def getOrder = call read('classpath:karate/core/oms/getOrderById.feature@GetOrderForSingleLineItem') {orderId : '#(orderId)'}
    Then print getOrder