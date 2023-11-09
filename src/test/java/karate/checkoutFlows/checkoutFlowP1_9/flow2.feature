@Sanity
Feature: Checkout with Bundle + Non-Variant Product with multi-tier promotion.

  Scenario: Checkout with Bundle + Non-Variant Product with multi-tier promotion.
    * def product  = call read('classpath:karate/core/pim/pim.feature@ForNonVariantItem') {ItemId : '#(Non_Variant_Multitier_Qua_Promo_ItemId)'}
    * def ItemAttributes = product.response.products[0].attributes
    * def ItemId = product.response.products[0].itemId
    * def sku = product.response.products[0].sku

    * def productBundle  = call read('classpath:karate/core/pim/pim.feature@ForBundleItem') {ItemId : '#(Bundle_Multitier_Qua_Promo_ItemId)'}
    * def ItemAttributesBundle = productBundle.response.products[0].attributes
    * def ItemIdBundle = productBundle.response.products[0].itemId
    * def Bundlesku = productBundle.response.products[0].sku

    * def price  = call read('classpath:karate/core/price/price.feature@PriceFor2Items') {ItemId1: '#(ItemId)', ItemId2: '#(Bundle_Multitier_Qua_Promo_ItemId)'}


    * def inventoryForItem  = call read('classpath:karate/core/inventory/inventory.feature@InventoryConfiguredItem') {sku : '#(sku)'}
    * def inventoryForBundle  = call read('classpath:karate/core/inventory/inventory.feature@InventoryConfiguredItem') {sku : '#(Bundlesku)'}
<<<<<<< HEAD

    * def cart = call read('classpath:karate/core/cart/addToCart.feature@PromotionalCartWithMultiLineItem') {ItemId1: '#(ItemId)', ItemAttributes1:'#(ItemAttributes)', ItemId2: '#(ItemIdBundle)', ItemAttributes2:'#(ItemAttributesBundle)'}
=======
    * def inventoryChannelForItem1 = inventoryForItem.response.inventory[0].channelId
    * def inventoryChannelForItem2 = inventoryForBundle.response.inventory[0].channelId
    * def cart = call read('classpath:karate/core/cart/addToCart.feature@PromotionalCartWithMultiLineItem') {ItemId1: '#(ItemId)', ItemAttributes1:'#(ItemAttributes)', ItemId2: '#(ItemIdBundle)', ItemAttributes2:'#(ItemAttributesBundle)',InventoryChannelForItem1: '#(inventoryChannelForItem1)', InventoryChannelForItem2: '#(inventoryChannelForItem2)'}
>>>>>>> 8e47116a24493956fbedad60f5babe29903cb3a8

    * def cartId = cart.response.cartId

    * def cartQuantity = call read('classpath:karate/core/cart/updateQuantity.feature@UpdateQtyForMultiLineItemAndMultiTierQuantityCoupon') {ItemId: '#(ItemId)', cartId: '#(cartId)', Quantity: '2' }

    * def shippingDetails = call read('classpath:karate/core/oms/GetShippingByID.feature') {shippingId: '#(shipMethodId)'}

    * def shippingId = shippingDetails.response.shippingMethodId

    * def shippingCost = shippingDetails.response.cost

<<<<<<< HEAD
    * def createShipTo = call read('classpath:karate/core/cart/createShipTo.feature') {cartId: '#(cartId)', shippingMethodId: '#(shippingId)', shippingCost: '#(shippingCost)' }
=======
    * def createShipTo = call read('classpath:karate/core/cart/createShipTo.feature@WEB_SHIP') {cartId: '#(cartId)', shippingMethodId: '#(shippingId)', shippingCost: '#(shippingCost)' }
>>>>>>> 8e47116a24493956fbedad60f5babe29903cb3a8

    * def shipToId = createShipTo.response.shipToId

    * def addShipToCart = call read('classpath:karate/core/cart/addShippingToCart.feature@MultipleLineItem') {cartId: '#(cartId)', shipToId: '#(shipToId)', ItemId1: '#(ItemId)', ItemId2: '#(ItemIdBundle)'}

    * def getCart = call read('classpath:karate/core/cart/getCart.feature@@GetCartWithMultiLineItem') {cartID: '#(cartId)' }

    * def cartAmount = getCart.response.totalAmount - shippingCost

    * def checkout = call read('classpath:karate/core/checkout/checkout.feature@CheckoutMultipleLineItem') {cartId: '#(cartId)', shipToId: '#(shipToId)', shippingCost: '#(shippingCost)', cartTotal: '#(cartAmount)'}
    * def orderId = checkout.response.orderId
    * def getOrder = call read('classpath:karate/core/oms/getOrderById.feature@GetOrderForMultiLineItem') {orderId : '#(orderId)'}
    Then print getOrder