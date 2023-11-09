@Sanity
Feature: Checkout with variant and Non Variant product with ALL SKU AMOUNT Off coupon

  Scenario: ALL SKU Coupon Applied to Cart With Variant Item
    * def variantProduct  = call read('classpath:karate/core/pim/pim.feature@ForVariantItem') {ItemId : '#(variant_itemId)'}
    * def ItemId1 = variantProduct.response.products[0].children[0].itemId
    * def ItemId2 = variantProduct.response.products[0].children[1].itemId
    * def ItemId1Attributes = variantProduct.response.products[0].children[0].attributes
    * def ItemId2Attributes = variantProduct.response.products[0].children[1].attributes
    * def sku1 = variantProduct.response.products[0].children[0].sku
    * def sku2 = variantProduct.response.products[0].children[1].sku

    * def nonVariantProduct  = call read('classpath:karate/core/pim/pim.feature@ForNonVariantItem') {ItemId : '#(non_variant_itemId)'}
    * def ItemAttributes = nonVariantProduct.response.products[0].attributes
    * def ItemId = nonVariantProduct.response.products[0].itemId
    * def sku =  nonVariantProduct.response.products[0].sku

    * def price  = call read('classpath:karate/core/price/price.feature@PriceFor2Items') {ItemId1: '#(ItemId1)', ItemId2: '#(ItemId)'}


    * def inventoryForItem1  = call read('classpath:karate/core/inventory/inventory.feature@InventoryConfiguredItem') {sku : '#(sku1)'}
    * def inventoryForItem2  = call read('classpath:karate/core/inventory/inventory.feature@InventoryConfiguredItem') {sku : '#(sku)'}
    * def inventoryChannelForItem1 = inventoryForItem1.response.inventory[0].channelId
    * def inventoryChannelForItem2 = inventoryForItem2.response.inventory[0].channelId
    * def cart = call read('classpath:karate/core/cart/addToCart.feature@AddingMultipleItemToCart') {ItemId1: '#(ItemId1)', ItemAttributes1:'#(ItemId1Attributes)', ItemId2: '#(ItemId)', ItemAttributes2:'#(ItemAttributes)',InventoryChannelForItem1: '#(inventoryChannelForItem1)', InventoryChannelForItem2: '#(inventoryChannelForItem2)'}
    * def cartId = cart.response.cartId
    * def applyCoupon = call read('classpath:karate/core/cart/applyCoupon.feature@SingleLineItem') {cartId: '#(cartId)', couponCode : '#(ALL_SKU_COUPON)'}

    * def shippingDetails = call read('classpath:karate/core/oms/GetShippingByID.feature') {shippingId: '#(shipMethodId)'}
    * def shippingId = shippingDetails.response.shippingMethodId
    * def shippingCost = shippingDetails.response.cost
    * def createShipTo = call read('classpath:karate/core/cart/createShipTo.feature@WEB_SHIP') {cartId: '#(cartId)', shippingMethodId: '#(shippingId)', shippingCost: '#(shippingCost)' }

    * def shipToId = createShipTo.response.shipToId

    * def addShipToCart = call read('classpath:karate/core/cart/addShippingToCart.feature@MultipleLineItem') {cartId: '#(cartId)', shipToId: '#(shipToId)', ItemId1: '#(ItemId1)', ItemId2: '#(ItemId)'}

    * def cartAmount = applyCoupon.response.totalAmount

    * def checkout = call read('classpath:karate/core/checkout/checkout.feature@CheckoutMultipleLineItem') {cartId: '#(cartId)', shipToId: '#(shipToId)', shippingCost: '#(shippingCost)', cartTotal: '#(cartAmount)'}
    * def orderId = checkout.response.orderId
    * def getOrder = call read('classpath:karate/core/oms/getOrderById.feature@GetOrderForMultiLineItem') {orderId : '#(orderId)'}
    Then print getOrder