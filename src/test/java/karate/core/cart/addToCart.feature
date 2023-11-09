Feature: Cart

  Background:

    * url cart_endpoint
    * def cart_x_api_key = cart_x_api_key
    * def quantity = __arg.quantity
    * print quantity

  @AddingSingleItemToCart
  Scenario: Add to Cart
    Given path 'items'
    And header  x-site-context = {account: '#(account)', stage: '#(stage)'}
    And header x-api-key = cart_x_api_key
    And header Content-Type = 'application/json'
    And request { "cartId": null, "items": [{"type":"WEB_SHIP","itemId": "#(__arg.ItemId)","quantity": "1","price": { currency: "US" }, "fulfillment":{"type":"WEB_SHIP","networkCode":"ShipToHome","channelId":"#(__arg.InventoryChannelForItem1)"}}]}
    When method post
    Then status 200
    And print response
    And assert response.cartId != null && response.cartId != ''
    And assert response.cartState == 'PENDING'
    And print response.items[0].attributes.length
    And print ItemAttributes.length
    And assert response.items[0].attributes.length == __arg.ItemAttributes.length

  @AddingMultipleItemToCart
  Scenario: Add to Cart
    Given path 'items'
    And header  x-site-context = {account: '#(account)', stage: '#(stage)'}
    And header x-api-key = cart_x_api_key
    And header Content-Type = 'application/json'
    And request { "cartId": null, "items": [{"type":"WEB_SHIP", "itemId": "#(__arg.ItemId1)","quantity": "1","price": { currency: "US" },"fulfillment":{"type":"WEB_SHIP","networkCode":"ShipToHome","channelId":"#(__arg.InventoryChannelForItem1)"}}, {"type":"WEB_SHIP","itemId": "#(__arg.ItemId2)","quantity": "1","price": { currency: "US" },"fulfillment":{"type":"WEB_SHIP","networkCode":"ShipToHome","channelId":"#(__arg.InventoryChannelForItem2)"}}]}
    When method post
    Then status 200
    And print response
    And assert response.cartId != null && response.cartId != ''
    And assert response.cartState == 'PENDING'
    And assert response.items[0].attributes.length == __arg.ItemAttributes1.length
    And assert response.items[1].attributes.length == __arg.ItemAttributes2.length

  @PromotionalCartWithSingleLineItem
  Scenario: Add to Cart
    Given path 'items'
    And header  x-site-context = {account: '#(account)', stage: '#(stage)'}
    And header x-api-key = cart_x_api_key
    And header Content-Type = 'application/json'
    And request { "cartId": null, "items": [{"type":"WEB_SHIP","itemId": "#(__arg.ItemId)","quantity": "1","price": { currency: "US" },"fulfillment":{"type":"WEB_SHIP","networkCode":"ShipToHome","channelId":"#(__arg.InventoryChannelForItem1)"}}]}
    When method post
    Then status 200
    And print response
    And assert response.cartId != null && response.cartId != ''
    And assert response.cartState == 'PENDING'
    And assert response.items[0].attributes.length == __arg.ItemAttributes.length
    And assert response.allPromosApplied.length > 0
    And assert response.subTotal == response.totalAmount + response.totalDiscount
    And assert response.items[0].totalPrice.amount > response.items[0].totalPrice.sale
    And assert response.items[0].totalPrice.discount.discounts.length > 0
    And assert response.items[0].totalPrice.amount == response.items[0].totalPrice.sale + response.items[0].totalPrice.discount.discountAmount

  @PromotionalCartWithMultiLineItem
  Scenario: Add to Cart
    Given path 'items'
    And header  x-site-context = {account: '#(account)', stage: '#(stage)'}
    And header x-api-key = cart_x_api_key
    And header Content-Type = 'application/json'
    And request { "cartId": null, "items": [{"type":"WEB_SHIP","itemId": "#(__arg.ItemId1)","quantity": "1","price": { currency: "US" },"fulfillment":{"type":"WEB_SHIP","networkCode":"ShipToHome","channelId":"#(__arg.InventoryChannelForItem1)"}}, {"type":"WEB_SHIP","itemId": "#(__arg.ItemId2)","quantity": "1","price": { currency: "US" },"fulfillment":{"type":"WEB_SHIP","networkCode":"ShipToHome","channelId":"#(__arg.InventoryChannelForItem2)"}}]}
    When method post
    Then status 200
    And print response
    And assert response.cartId != null && response.cartId != ''
    And assert response.cartState == 'PENDING'
    And assert response.items[0].attributes.length == __arg.ItemAttributes1.length
    And assert response.items[1].attributes.length == __arg.ItemAttributes2.length
    And assert response.allPromosApplied.length > 0
    And assert response.subTotal == response.totalAmount + response.totalDiscount
    And assert response.items[0].totalPrice.amount >= response.items[0].totalPrice.sale
    And assert response.items[0].totalPrice.discount.discounts.length > 0
    And assert response.items[0].totalPrice.amount == response.items[0].totalPrice.sale + response.items[0].totalPrice.discount.discountAmount
    And assert response.items[1].totalPrice.amount >= response.items[1].totalPrice.sale
    And assert response.items[1].totalPrice.amount == response.items[1].totalPrice.sale + response.items[1].totalPrice.discount.discountAmount

  @PromotionalCartWithSingleLineItemWithMultiPleQua
  Scenario: Add to Cart
    Given path 'items'
    And header  x-site-context = {account: '#(account)', stage: '#(stage)'}
    And header x-api-key = cart_x_api_key
    And header Content-Type = 'application/json'
    And request { "cartId": null, "items": [{"type":"WEB_SHIP","itemId": "#(__arg.ItemId)","quantity": '#(quantity)',"price": { currency: "US" },"fulfillment":{"type":"WEB_SHIP","networkCode":"ShipToHome","channelId":"#(__arg.InventoryChannelForItem1)"}}]}
    When method post
    Then status 200
    And print response
    And assert response.cartId != null && response.cartId != ''
    And assert response.cartState == 'PENDING'
    And assert response.items[0].attributes.length == __arg.ItemAttributes.length
    And assert response.allPromosApplied.length > 0
    And assert response.subTotal == response.totalAmount + response.totalDiscount
    And assert response.items[0].totalPrice.amount > response.items[0].totalPrice.sale
    And assert response.items[0].totalPrice.discount.discounts.length > 0
    And assert response.items[0].totalPrice.amount == response.items[0].totalPrice.sale + response.items[0].totalPrice.discount.discountAmount

  @AddingSingleItemToCartWithExpiredPromotion
    # same as asserting if a cart has no promotions
  Scenario: Add to Cart
    Given path 'items'
    And header  x-site-context = {account: '#(account)', stage: '#(stage)'}
    And header x-api-key = cart_x_api_key
    And header Content-Type = 'application/json'
    And request { "cartId": null, "items": [{"type":"WEB_SHIP","itemId": "#(__arg.ItemId)","quantity": "1","price": { currency: "US" },"fulfillment":{"type":"WEB_SHIP","networkCode":"ShipToHome","channelId":"#(__arg.InventoryChannelForItem1)"}}]}
    When method post
    Then status 200
    And print response
    And assert response.cartId != null && response.cartId != ''
    And assert response.cartState == 'PENDING'
    And print response.items[0].attributes.length
    And print ItemAttributes.length
    And assert response.items[0].attributes.length == __arg.ItemAttributes.length

  @AddingNon_PriceItem
  Scenario: Add to Cart
    Given path 'items'
    And header  x-site-context = {account: '#(account)', stage: '#(stage)'}
    And header x-api-key = cart_x_api_key
    And header Content-Type = 'application/json'
    And request { "cartId": null, "items": [{"type":"WEB_SHIP","itemId": "#(__arg.ItemId)","quantity": "1","price": { currency: "US" },"fulfillment":{"type":"WEB_SHIP","networkCode":"ShipToHome","channelId":"#(__arg.InventoryChannelForItem1)"}}]}
    When method post
    And print response
    * def expectedCodes = ["UNABLE_TO_GET_PRICE", "UNABLE_TO_GET_PROMO"]
    * def responseCode = response.code
    And match expectedCodes contains responseCode
    And karate.match(response, { totalItems: '#present' }).failed
    Then print "Error: Unable to get Price"

  @AddingNon_InventoryItem
  Scenario: Add to Cart
    Given path 'items'
    And header  x-site-context = {account: '#(account)', stage: '#(stage)'}
    And header x-api-key = cart_x_api_key
    And header Content-Type = 'application/json'
    And request { "cartId": null, "items": [{"type":"WEB_SHIP","itemId": "#(__arg.ItemId)","quantity": "1","price": { currency: "US" },"fulfillment":{"type":"WEB_SHIP","networkCode":"ShipToHome","channelId":"#(__arg.InventoryChannelForItem1)"}}]}
    When method post
    Then assert responseStatus == 400
    And print response
    And assert response.details[0].code == "ITEM_OUT_OF_STOCK"
    And assert response.code == "ITEM_OUT_OF_STOCK"
    And print "Error: The inventory doesn't configured for the item"


  @AddingMultipleItemToCartWithGiftWrap
  Scenario: Add to Cart
    Given path 'items'
    And header  x-site-context = {account: '#(account)', stage: '#(stage)'}
    And header x-api-key = cart_x_api_key
    And header Content-Type = 'application/json'
    And request { "cartId": null, "items": [{"type":"WEB_SHIP","itemId": "#(__arg.ItemId1)","quantity": "1","price": { currency: "US" }, "fulfillment":{"type":"WEB_SHIP","networkCode":"ShipToHome","channelId":"#(__arg.InventoryChannelForItem1)"},"extra" :{"isGift" :  true}}, {"type":"WEB_SHIP","itemId": "#(__arg.ItemId2)","quantity": "1","price": { currency: "US" },"fulfillment":{"type":"WEB_SHIP","networkCode":"ShipToHome","channelId":"#(__arg.InventoryChannelForItem2)"},"extra" :{"isGift" :  true}}]}
    When method post
    Then status 200
    And print response
    And assert response.cartId != null && response.cartId != ''
    And assert response.cartState == 'PENDING'
    And assert response.items[0].attributes.length == __arg.ItemAttributes1.length
    And assert response.items[1].attributes.length == __arg.ItemAttributes2.length
    And assert response.items[0].extra.isGift == true
    And assert response.items[1].extra.isGift == true

  @AddingMultipleItemToCartBOPIS
  Scenario: Add to Cart
    Given path 'items'
    And header  x-site-context = {account: '#(account)', stage: '#(stage)'}
    And header x-api-key = cart_x_api_key
    And header Content-Type = 'application/json'
    And request { "cartId": null, "items": [{"type":"WEB_PICKUP", "itemId": "#(__arg.ItemId1)","quantity": "1","price": { currency: "US" },"fulfillment":{"type":"WEB_PICKUP","networkCode":"ShipToHome","channelId":"#(__arg.InventoryChannelForItem1)"}}, {"type":"WEB_PICKUP","itemId": "#(__arg.ItemId2)","quantity": "1","price": { currency: "US" },"fulfillment":{"type":"WEB_PICKUP","networkCode":"ShipToHome","channelId":"#(__arg.InventoryChannelForItem2)"}}]}
    When method post
    Then status 200
    And print response
    And assert response.cartId != null && response.cartId != ''
    And assert response.cartState == 'PENDING'
    And assert response.items[0].attributes.length == __arg.ItemAttributes1.length
    And assert response.items[1].attributes.length == __arg.ItemAttributes2.length

  @AddingSingleItemToCartBOPIS
  Scenario: Add to Cart
    Given path 'items'
    And header  x-site-context = {account: '#(account)', stage: '#(stage)'}
    And header x-api-key = cart_x_api_key
    And header Content-Type = 'application/json'
    And request { "cartId": null, "items": [{"type":"WEB_PICKUP","itemId": "#(__arg.ItemId)","quantity": "1","price": { currency: "US" }, "fulfillment":{"type":"WEB_PICKUP","networkCode":"ShipToHome","channelId":"#(__arg.InventoryChannelForItem1)"}}]}
    When method post
    Then status 200
    And print response
    And assert response.cartId != null && response.cartId != ''
    And assert response.cartState == 'PENDING'
    And print response.items[0].attributes.length
    And print ItemAttributes.length
    And assert response.items[0].attributes.length == __arg.ItemAttributes.length

