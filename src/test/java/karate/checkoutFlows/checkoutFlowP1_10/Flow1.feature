@Sanity
Feature: Create BOPIS Order with variant + Non Variant Product

  Scenario: Create BOPIS Order with variant + Non Variant Product

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
    * def cart = call read('classpath:karate/core/cart/addToCart.feature@AddingMultipleItemToCartBOPIS') {ItemId1: '#(ItemId1)', ItemAttributes1:'#(ItemId1Attributes)', ItemId2: '#(ItemId)', ItemAttributes2:'#(ItemAttributes)',InventoryChannelForItem1: '#(inventoryChannelForItem1)', InventoryChannelForItem2: '#(inventoryChannelForItem2)'}

    * def inventoryLocationForItem1 = call read('classpath:karate/core/inventory/inventory.feature@InventoryConfiguredItemForBOPIS') {sku : '#(sku1)', channels: '#(inventoryChannelForItem1)'}
    * def inventoryLocationForItem2 = call read('classpath:karate/core/inventory/inventory.feature@InventoryConfiguredItemForBOPIS') {sku : '#(sku)', channels: '#(inventoryChannelForItem2)'}

    * def cartId = cart.response.cartId
    * def locationNumForItem1 = inventoryLocationForItem1.response.inventory[0].locationNum
    * def locationNumForItem2 = inventoryLocationForItem2.response.inventory[0].locationNum
    * def createShipToForItem1 = call read('classpath:karate/core/cart/createShipTo.feature@BOPIS') {cartId: '#(cartId)', locationNum:'#(locationNumForItem1)'}
    * def createShipToForItem2 = call read('classpath:karate/core/cart/createShipTo.feature@BOPIS') {cartId: '#(cartId)', locationNum:'#(locationNumForItem2)'}

    * def shipToId_1 = createShipToForItem1.response.shipToId
    * def shipToId_2 = createShipToForItem2.response.shipToId

    * def addShipToCart = call read('classpath:karate/core/cart/addShippingToCart.feature@MultipleLineItemWithMultiShipping')
    * def cartAmount = addShipToCart.response.totalAmount
    * print cartAmount

    * def checkout = call read('classpath:karate/core/checkout/checkout.feature@CheckoutMultipleLineItemWithMultiShipId') {cartId: '#(cartId)', shipToId: '#(shipToId)', shippingCost: 0, cartTotal: 1}
    * def orderId = checkout.response.orderId
    * def getOrder = call read('classpath:karate/core/oms/getOrderById.feature@GetOrderForMultiLineItemWithMultipleShipIdBOPIS') {orderId : '#(orderId)'}
    Then print getOrder