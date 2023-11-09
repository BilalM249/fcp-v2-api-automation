@Sanity
Feature: Checkout with Variant + Non-Variant Product with multi-tier promotion.

  Scenario: Checkout with Variant + Non-Variant Product with multi-tier promotion.
    * def variantProduct  = call read('classpath:karate/core/pim/pim.feature@ForVariantItem') {ItemId : '#(Variant_Multitier_Qua_Promo_ItemId)'}
    * def ItemId1 = variantProduct.response.products[0].children[0].itemId
    * def ItemId2 = variantProduct.response.products[0].children[1].itemId
    * def ItemId1Attributes = variantProduct.response.products[0].children[0].attributes
    * def ItemId2Attributes = variantProduct.response.products[0].children[1].attributes
    * def sku1 = variantProduct.response.products[0].children[0].sku
    * def sku2 = variantProduct.response.products[0].children[1].sku

    * def nonVariantProduct  = call read('classpath:karate/core/pim/pim.feature@ForNonVariantItem') {ItemId : '#(Non_Variant_Multitier_Qua_Promo_ItemId)'}
    * def ItemAttributes = nonVariantProduct.response.products[0].attributes
    * def ItemId = nonVariantProduct.response.products[0].itemId
    * def sku =  nonVariantProduct.response.products[0].sku

    * def price  = call read('classpath:karate/core/price/price.feature@PriceFor2Items') {ItemId1: '#(ItemId1)', ItemId2: '#(ItemId)'}


    * def inventoryForItem1  = call read('classpath:karate/core/inventory/inventory.feature@InventoryConfiguredItem') {sku : '#(sku1)'}
    * def inventoryForItem2  = call read('classpath:karate/core/inventory/inventory.feature@InventoryConfiguredItem') {sku : '#(sku)'}
<<<<<<< HEAD

    * def cart = call read('classpath:karate/core/cart/addToCart.feature@PromotionalCartWithMultiLineItem') {ItemId1: '#(ItemId)', ItemAttributes1:'#(ItemAttributes)', ItemId2: '#(ItemId1)', ItemAttributes2:'#(ItemId1Attributes)'}
=======
    * def inventoryChannelForItem1 = inventoryForItem1.response.inventory[0].channelId
    * def inventoryChannelForItem2 = inventoryForItem2.response.inventory[0].channelId
    * def cart = call read('classpath:karate/core/cart/addToCart.feature@PromotionalCartWithMultiLineItem') {ItemId1: '#(ItemId)', ItemAttributes1:'#(ItemAttributes)', ItemId2: '#(ItemId1)', ItemAttributes2:'#(ItemId1Attributes)',InventoryChannelForItem1: '#(inventoryChannelForItem1)', InventoryChannelForItem2: '#(inventoryChannelForItem2)'}
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

    * def addShipToCart = call read('classpath:karate/core/cart/addShippingToCart.feature@MultipleLineItem') {cartId: '#(cartId)', shipToId: '#(shipToId)', ItemId1: '#(ItemId)', ItemId2: '#(ItemId1)'}

    * def getCart = call read('classpath:karate/core/cart/getCart.feature@@GetCartWithMultiLineItem') {cartID: '#(cartId)' }

    * def cartAmount = getCart.response.totalAmount - shippingCost

    * def checkout = call read('classpath:karate/core/checkout/checkout.feature@CheckoutMultipleLineItem') {cartId: '#(cartId)', shipToId: '#(shipToId)', shippingCost: '#(shippingCost)', cartTotal: '#(cartAmount)'}
    * def orderId = checkout.response.orderId
    * def getOrder = call read('classpath:karate/core/oms/getOrderById.feature@GetOrderForMultiLineItem') {orderId : '#(orderId)'}
    Then print getOrder