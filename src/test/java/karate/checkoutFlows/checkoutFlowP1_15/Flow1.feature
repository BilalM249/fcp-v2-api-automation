@Sanity
Feature: GiftWrap At Item Level

  Scenario: Add a  Non variant and bundle Item and Add giftWrap attribute to both items

    * def product  = call read('classpath:karate/core/pim/pim.feature@ForNonVariantItem') {ItemId : '#(non_variant_itemId)'}
    * def ItemAttributes = product.response.products[0].attributes
    * def ItemId = product.response.products[0].itemId
    * def sku = product.response.products[0].sku

    * def productBundle  = call read('classpath:karate/core/pim/pim.feature@ForBundleItem') {ItemId : '#(Bundle_ItemId)'}
    * def ItemAttributesBundle = productBundle.response.products[0].attributes
    * def ItemIdBundle = productBundle.response.products[0].itemId
    * def Bundlesku = productBundle.response.products[0].sku

    * def price  = call read('classpath:karate/core/price/price.feature@PriceFor2Items') {ItemId1: '#(ItemId)', ItemId2: '#(ItemIdBundle)'}


    * def inventoryForItem  = call read('classpath:karate/core/inventory/inventory.feature') {sku : '#(sku)'}
    * def inventoryForBundle  = call read('classpath:karate/core/inventory/inventory.feature') {sku : '#(Bundlesku)'}
    * def inventoryChannelForItem1 = inventoryForItem.response.inventory[0].channelId
    * def inventoryChannelForItem2 = inventoryForBundle.response.inventory[0].channelId
    * def cart = call read('classpath:karate/core/cart/addToCart.feature@AddingMultipleItemToCartWithGiftWrap') {ItemId1: '#(ItemId)', ItemAttributes1:'#(ItemAttributes)', ItemId2: '#(ItemIdBundle)', ItemAttributes2:'#(ItemAttributesBundle)',InventoryChannelForItem1: '#(inventoryChannelForItem1)', InventoryChannelForItem2: '#(inventoryChannelForItem2)'}

    * def shippingDetails = call read('classpath:karate/core/oms/GetShippingByID.feature') {shippingId: '#(shipMethodId)'}
    * def shippingId = shippingDetails.response.shippingMethodId
    * def shippingCost = shippingDetails.response.cost
    * def cartId = cart.response.cartId
    * def createShipTo = call read('classpath:karate/core/cart/createShipTo.feature@WEB_SHIP') {cartId: '#(cartId)', shippingMethodId: '#(shippingId)', shippingCost: '#(shippingCost)' }

    * def shipToId = createShipTo.response.shipToId

    * def addShipToCart = call read('classpath:karate/core/cart/addShippingToCart.feature@MultipleLineItem') {cartId: '#(cartId)', shipToId: '#(shipToId)', ItemId1: '#(ItemId)', ItemId2: '#(ItemIdBundle)'}

    * def cartAmount = cart.response.totalAmount

    * def checkout = call read('classpath:karate/core/checkout/checkout.feature@CheckoutMultipleLineItem') {cartId: '#(cartId)', shipToId: '#(shipToId)', shippingCost: '#(shippingCost)', cartTotal: '#(cartAmount)'}
    * def orderId = checkout.response.orderId
    * def getOrder = call read('classpath:karate/core/oms/getOrderById.feature@GetOrderForMultiLineItemForGiftWrap') {orderId : '#(orderId)'}
    Then print getOrder