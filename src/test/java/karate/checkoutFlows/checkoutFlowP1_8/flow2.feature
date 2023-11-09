@Sanity
Feature: Checkout with Bundle + Non-Variant Product with multi-tier coupon.

  Scenario: Checkout with Bundle + Non-Variant Product with multi-tier coupon.
    * def product  = call read('classpath:karate/core/pim/pim.feature@ForNonVariantItem') {ItemId : '#(non_variant_itemId)'}
    * def ItemAttributes = product.response.products[0].attributes
    * def ItemId = product.response.products[0].itemId
    * def sku = product.response.products[0].sku

    * def productBundle  = call read('classpath:karate/core/pim/pim.feature@ForBundleItem') {ItemId : '#(Bundle_ItemId)'}
    * def ItemAttributesBundle = productBundle.response.products[0].attributes
    * def ItemIdBundle = productBundle.response.products[0].itemId
    * def Bundlesku = productBundle.response.products[0].sku

    * def price  = call read('classpath:karate/core/price/price.feature@PriceFor2Items') {ItemId1: '#(ItemId)', ItemId2: '#(ItemIdBundle)'}


    * def inventoryForItem  = call read('classpath:karate/core/inventory/inventory.feature@InventoryConfiguredItem') {sku : '#(sku)'}
    * def inventoryForBundle  = call read('classpath:karate/core/inventory/inventory.feature@InventoryConfiguredItem') {sku : '#(Bundlesku)'}
    * def inventoryChannelForItem1 = inventoryForItem.response.inventory[0].channelId
    * def inventoryChannelForItem2 = inventoryForBundle.response.inventory[0].channelId
    * def cart = call read('classpath:karate/core/cart/addToCart.feature@AddingMultipleItemToCart') {ItemId1: '#(ItemId)', ItemAttributes1:'#(ItemAttributes)', ItemId2: '#(ItemIdBundle)', ItemAttributes2:'#(ItemAttributesBundle)',InventoryChannelForItem1: '#(inventoryChannelForItem1)', InventoryChannelForItem2: '#(inventoryChannelForItem2)'}

    * def shippingDetails = call read('classpath:karate/core/oms/GetShippingByID.feature') {shippingId: '#(shipMethodId)'}
    * def shippingId = shippingDetails.response.shippingMethodId
    * def shippingCost = shippingDetails.response.cost
    * def cartId = cart.response.cartId

    * def applyCoupon = call read('classpath:karate/core/cart/applyCoupon.feature@ApplyingMultiTierCoupon') {cartId: '#(cartId)', couponCode : '#(Non_Variant_Multitier_Quantity_Coupon)'}

    * def createShipTo = call read('classpath:karate/core/cart/createShipTo.feature@WEB_SHIP') {cartId: '#(cartId)', shippingMethodId: '#(shippingId)', shippingCost: '#(shippingCost)' }

    * def shipToId = createShipTo.response.shipToId

    * def cartQuantity = call read('classpath:karate/core/cart/updateQuantity.feature@UpdateQtyForMultiLineItemAndMultiTierQuantityCoupon') {ItemId: '#(ItemId)', cartId: '#(cartId)', Quantity: '2' }

    * def createShipTo = call read('classpath:karate/core/cart/createShipTo.feature@WEB_SHIP') {cartId: '#(cartId)', shippingMethodId: '#(shippingId)', shippingCost: '#(shippingCost)' }

    * def shipToId = createShipTo.response.shipToId

    * def addShipToCart = call read('classpath:karate/core/cart/addShippingToCart.feature@MultipleLineItem') {cartId: '#(cartId)', shipToId: '#(shipToId)', ItemId1: '#(ItemId)', ItemId2: '#(ItemIdBundle)'}

    * def cartAmount = cartQuantity.response.totalAmount

    * def checkout = call read('classpath:karate/core/checkout/checkout.feature@CheckoutMultipleLineItem') {cartId: '#(cartId)', shipToId: '#(shipToId)', shippingCost: '#(shippingCost)', cartTotal: '#(cartAmount)'}
    * def orderId = checkout.response.orderId
    * def getOrder = call read('classpath:karate/core/oms/getOrderById.feature@GetOrderForMultiLineItem') {orderId : '#(orderId)'}
    Then print getOrder