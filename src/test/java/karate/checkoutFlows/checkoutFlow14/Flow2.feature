@Sanity
Feature: Checkout with Non variant product Along with Buy X Get Y  AMT OFF Promotion

  Scenario: BUY  X And Get Y Promotion Applied to Cart with Non Variant Item
    * def product  = call read('classpath:karate/core/pim/pim.feature@ForNonVariantItem') {ItemId : '#(FCP_X_Y_PROMO_NON_Variant_ItemId)'}
    * def ItemAttributes = product.response.products[0].attributes
    * def ItemId = product.response.products[0].itemId
    * def price  = call read('classpath:karate/core/price/price.feature@PriceForSingleItems') {ItemId: '#(ItemId)'}
    * def sku = product.response.products[0].sku

    * def inventoryForItem  = call read('classpath:karate/core/inventory/inventory.feature@InventoryConfiguredItem') {sku : '#(sku)'}
    * def inventoryChannelForItem1 = inventoryForItem.response.inventory[0].channelId
    * def cart = call read('classpath:karate/core/cart/addToCart.feature@PromotionalCartWithSingleLineItemWithMultiPleQua') {ItemId: '#(ItemId)', ItemAttributes:'#(ItemAttributes)',  quantity:'3',InventoryChannelForItem1: '#(inventoryChannelForItem1)'}
    * def shippingDetails = call read('classpath:karate/core/oms/GetShippingByID.feature') {shippingId: '#(shipMethodId)'}
    * def shippingId = shippingDetails.response.shippingMethodId
    * def shippingCost = shippingDetails.response.cost
    * def cartId = cart.response.cartId
    * def createShipTo = call read('classpath:karate/core/cart/createShipTo.feature@WEB_SHIP') {cartId: '#(cartId)', shippingMethodId: '#(shippingId)', shippingCost: '#(shippingCost)' }

    * def shipToId = createShipTo.response.shipToId

    * def addShipToCart = call read('classpath:karate/core/cart/addShippingToCart.feature@SingleLineItem') {cartId: '#(cartId)', shipToId: '#(shipToId)', ItemId: '#(ItemId)'}

    * def cartAmount = cart.response.totalAmount

    * def checkout = call read('classpath:karate/core/checkout/checkout.feature@CheckoutSingleLineItem') {cartId: '#(cartId)', shipToId: '#(shipToId)', shippingCost: '#(shippingCost)', cartTotal: '#(cartAmount)'}
    * def orderId = checkout.response.orderId
    * def getOrder = call read('classpath:karate/core/oms/getOrderById.feature@GetOrderForSingleLineItem') {orderId : '#(orderId)'}
    Then print getOrder