@Sanity
Feature: Checkout with variant product Along with ALL SKU AMOUNT Off coupon

  Scenario: SBASFOSMU Coupon Applied to Cart with Variant Item
    * def product  = call read('classpath:karate/core/pim/pim.feature@ForVariantItem') {ItemId : '#(variant_itemId)'}
    * def ItemId1 = product.response.products[0].children[0].itemId
    * def ItemId2 = product.response.products[0].children[1].itemId
    * def ItemId1Attributes = product.response.products[0].children[0].attributes
    * def price  = call read('classpath:karate/core/price/price.feature@PriceFor2Items') {ItemId1: '#(ItemId1)', ItemId2: '#(ItemId2)'}
    * def sku1 = product.response.products[0].children[0].sku
    * def sku2 = product.response.products[0].children[1].sku
    * def inventoryForItem1  = call read('classpath:karate/core/inventory/inventory.feature@InventoryConfiguredItem') {sku : '#(sku1)'}
    * def inventoryForItem2  = call read('classpath:karate/core/inventory/inventory.feature@InventoryConfiguredItem') {sku : '#(sku2)'}
    * def inventoryChannelForItem1 = inventoryForItem1.response.inventory[0].channelId
    * def inventoryChannelForItem2 = inventoryForItem2.response.inventory[0].channelId
    * def cart = call read('classpath:karate/core/cart/addToCart.feature@AddingSingleItemToCart') {ItemId: '#(ItemId1)', ItemAttributes:'#(ItemId1Attributes)',InventoryChannelForItem1: '#(inventoryChannelForItem1)'}
    * def cartId = cart.response.cartId
    * def applyCoupon = call read('classpath:karate/core/cart/applyCoupon.feature@SingleLineItem') {cartId: '#(cartId)', couponCode : '#(ALL_SKU_COUPON)'}

    * def shippingDetails = call read('classpath:karate/core/oms/GetShippingByID.feature') {shippingId: '#(shipMethodId)'}
    * def shippingId = shippingDetails.response.shippingMethodId
    * def shippingCost = shippingDetails.response.cost

    * def createShipTo = call read('classpath:karate/core/cart/createShipTo.feature@WEB_SHIP') {cartId: '#(cartId)', shippingMethodId: '#(shippingId)', shippingCost: '#(shippingCost)' }

    * def shipToId = createShipTo.response.shipToId

    * def addShipToCart = call read('classpath:karate/core/cart/addShippingToCart.feature@SingleLineItem') {cartId: '#(cartId)', shipToId: '#(shipToId)', ItemId: '#(ItemId1)'}

    * def cartAmount = applyCoupon.response.totalAmount

    * def checkout = call read('classpath:karate/core/checkout/checkout.feature@CheckoutSingleLineItem') {cartId: '#(cartId)', shipToId: '#(shipToId)', shippingCost: '#(shippingCost)', cartTotal: '#(cartAmount)'}
    * def orderId = checkout.response.orderId
    * def getOrder = call read('classpath:karate/core/oms/getOrderById.feature@GetOrderForSingleLineItem') {orderId : '#(orderId)'}
    Then print getOrder