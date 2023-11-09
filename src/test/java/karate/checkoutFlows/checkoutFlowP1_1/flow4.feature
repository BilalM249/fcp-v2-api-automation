@Sanity
Feature: Checkout with Non-Variant Product  + Bundle and Coupon is applicable on clearance price.
  Background:
    * def skipTest = karate.env == 'prod01'
  Scenario: Checkout with Non-Variant Product  + Bundle and Coupon is applicable on clearance price.
    * print skipTest
    * if (skipTest) karate.abort()
    #BUNDLE Product Getting Item, Price and Inventory Details
    * def product  = call read('classpath:karate/core/pim/pim.feature@ForBundleItem') {ItemId : '#(Clearance_Bundle_ItemId)'}
    * def BItemAttributes = product.response.products[0].attributes
    * def BItemId = product.response.products[0].itemId
    * def Bsku = product.response.products[0].sku
    * def Bprice  = call read('classpath:karate/core/price/price.feature@ClearancePriceForSingleItem') {ItemId: '#(BItemId)'}

    * def inventoryForItem  = call read('classpath:karate/core/inventory/inventory.feature@InventoryConfiguredItem') {sku : '#(Bsku)'}
    * def inventoryChannelForItem1 = inventoryForItem.response.inventory[0].channelId

    #Non Variant Product Getting Item, Price and Inventory Details
    * def nonVariantProduct  = call read('classpath:karate/core/pim/pim.feature@ForNonVariantItem') {ItemId : '#(Clearance_Non_Variant_ItemId)'}
    * def ItemAttributes = nonVariantProduct.response.products[0].attributes
    * def ItemId = nonVariantProduct.response.products[0].itemId
    * def sku =  nonVariantProduct.response.products[0].sku

    * def price  = call read('classpath:karate/core/price/price.feature@ClearancePriceForSingleItem') {ItemId: '#(ItemId)'}

    * def inventoryForNonVItem  = call read('classpath:karate/core/inventory/inventory.feature@InventoryConfiguredItem') {sku : '#(sku)'}

    * def inventoryChannelForItem2 = inventoryForNonVItem.response.inventory[0].channelId
    * def cart = call read('classpath:karate/core/cart/addToCart.feature@AddingMultipleItemToCart') {ItemId1: '#(BItemId)', ItemAttributes1:'#(BItemAttributes)', ItemId2: '#(ItemId)', ItemAttributes2:'#(ItemAttributes)',InventoryChannelForItem1: '#(inventoryChannelForItem1)', InventoryChannelForItem2: '#(inventoryChannelForItem2)'}
    * def cartId = cart.response.cartId
    * def applyCoupon = call read('classpath:karate/core/cart/applyCoupon.feature@MultiLineAllCLRItem') {cartId: '#(cartId)', couponCode : '#(Clearance_ALL_SKU_COUPON)'}

    * def shippingDetails = call read('classpath:karate/core/oms/GetShippingByID.feature') {shippingId: '#(shipMethodId)'}
    * def shippingId = shippingDetails.response.shippingMethodId
    * def shippingCost = shippingDetails.response.cost
    * def createShipTo = call read('classpath:karate/core/cart/createShipTo.feature@WEB_SHIP') {cartId: '#(cartId)', shippingMethodId: '#(shippingId)', shippingCost: '#(shippingCost)' }

    * def shipToId = createShipTo.response.shipToId

    * def addShipToCart = call read('classpath:karate/core/cart/addShippingToCart.feature@MultipleLineItem') {cartId: '#(cartId)', shipToId: '#(shipToId)', ItemId1: '#(BItemId)', ItemId2: '#(ItemId)'}

    * def cartAmount = applyCoupon.response.totalAmount

    * def checkout = call read('classpath:karate/core/checkout/checkout.feature@CheckoutMultipleLineItem') {cartId: '#(cartId)', shipToId: '#(shipToId)', shippingCost: '#(shippingCost)', cartTotal: '#(cartAmount)'}
    * def orderId = checkout.response.orderId
    * def getOrder = call read('classpath:karate/core/oms/getOrderById.feature@GetOrderForMultiLineItem') {orderId : '#(orderId)'}
    Then print getOrder