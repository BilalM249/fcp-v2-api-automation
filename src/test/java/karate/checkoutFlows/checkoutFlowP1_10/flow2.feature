@Sanity
Feature: Checkout BOPIS with Bundle product

  Scenario: BOPIS With Bundle  Item
    * def product  = call read('classpath:karate/core/pim/pim.feature@ForBundleItem') {ItemId : '#(Bundle_ItemId)'}
    * def ItemAttributes = product.response.products[0].attributes
    * def ItemId = product.response.products[0].itemId
    * def price  = call read('classpath:karate/core/price/price.feature@PriceForSingleItems') {ItemId: '#(ItemId)'}
    * def sku = product.response.products[0].sku

    * def inventoryForItem  = call read('classpath:karate/core/inventory/inventory.feature@InventoryConfiguredItem') {sku : '#(sku)'}
    * def inventoryChannelForItem1 = inventoryForItem.response.inventory[0].channelId
    * def cart = call read('classpath:karate/core/cart/addToCart.feature@AddingSingleItemToCartBOPIS') {ItemId: '#(ItemId)', ItemAttributes:'#(ItemAttributes)',InventoryChannelForItem1: '#(inventoryChannelForItem1)'}

    * def cartId = cart.response.cartId
    * def inventoryLocationForItem1 = call read('classpath:karate/core/inventory/inventory.feature@InventoryConfiguredItemForBOPIS') {sku : '#(sku)', channels: '#(inventoryChannelForItem1)'}
    * def lNum = inventoryLocationForItem1.response.inventory[0].locationNum
    * def createShipTo = call read('classpath:karate/core/cart/createShipTo.feature@BOPIS') {cartId: '#(cartId)', locationNum : '#(lNum)'}

    * def shipToId = createShipTo.response.shipToId

    * def addShipToCart = call read('classpath:karate/core/cart/addShippingToCart.feature@SingleLineItem') {cartId: '#(cartId)', shipToId: '#(shipToId)', ItemId: '#(ItemId)'}

    * def cartAmount = addShipToCart.response.totalAmount

    * def checkout = call read('classpath:karate/core/checkout/checkout.feature@CheckoutSingleLineItem') {cartId: '#(cartId)', shipToId: '#(shipToId)', shippingCost: 0, cartTotal: '#(cartAmount)'}
    * def orderId = checkout.response.orderId
    * def getOrder = call read('classpath:karate/core/oms/getOrderById.feature@GetOrderForSingleLineItemBOPIS') {orderId : '#(orderId)'}
    Then print getOrder