Feature: creating cart

  Background:

    * url cart_endpoint
    * def cart_x_api_key = cart_x_api_key



  @EmptyCart
  Scenario: create empty cart
    And header  x-site-context = {account: '#(account)', stage: '#(stage)'}
    And header x-api-key = cart_x_api_key
    And header Content-Type = 'application/json'
    And request {"name":"test","configuration":{"allowAnonymousUser":true,"orderNumberSource":"CART_ID","softReserve":false,"addItemBySku":true,"orderNumberGeneration":"NONE"}}
    When method post
    Then status 200
    And print response
    And assert response.totalItems == 0
    And assert response.totalUniqueItems == 0
    And assert response.configuration.addItemBySku == true
    And assert response.cartId != null && response.cartId != ''



    @AddItemToEmptyCartWithSKU
    Scenario: Add to Cart
      Given path 'items'
      And header  x-site-context = {account: '#(account)', stage: '#(stage)'}
      And header x-api-key = cart_x_api_key
      And header Content-Type = 'application/json'
      And print cartId
      And request { "cartId": "#(cartId)", "items": [{"type":"WEB_SHIP","sku": "#(__arg.sku)","quantity": "1","price": { currency: "US" }, "fulfillment":{"type":"WEB_SHIP","networkCode":"ShipToHome","channelId":"#(__arg.InventoryChannelForItem1)"}}]}
      When method post
      Then status 200
      And print response
      And assert response.cartId != null && response.cartId != ''
      And assert response.cartState == 'PENDING'
      And print response.items[0].attributes.length
      And print ItemAttributes.length
      And assert response.items[0].attributes.length == __arg.ItemAttributes.length


  @AddMultipleItemToEmptyCartWithSKU
  Scenario: Add to Cart
    Given path 'items'
    And header  x-site-context = {account: '#(account)', stage: '#(stage)'}
    And header x-api-key = cart_x_api_key
    And header Content-Type = 'application/json'
    And print cartId
    And request { "cartId": "#(cartId)", "items": [{"type":"WEB_SHIP","sku": "#(__arg.sku)","quantity": "1","price": { currency: "US" }, "fulfillment":{"type":"WEB_SHIP","networkCode":"ShipToHome","channelId":"#(__arg.InventoryChannelForItem1)"}},{"type":"WEB_SHIP","sku": "#(__arg.sku2)","quantity": "1","price": { currency: "US" }, "fulfillment":{"type":"WEB_SHIP","networkCode":"ShipToHome","channelId":"#(__arg.InventoryChannelForItem1)"}}]}
    When method post
    Then status 200
    And print response
    And assert response.cartId != null && response.cartId != ''
    And assert response.cartState == 'PENDING'
    And print response.items[0].attributes.length
    And print ItemAttributes.length
    And assert response.items[0].attributes.length == __arg.ItemAttributes.length
