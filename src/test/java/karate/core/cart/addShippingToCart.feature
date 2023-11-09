Feature: Add Ship To Cart

  Background:
    * def cart_x_api_key = cart_x_api_key
    * url cart_endpoint



  @SingleLineItem
  Scenario: Add shipTo for a cart
    Given path  __arg.cartId + '/items/shipping-details'
    And header  x-site-context = {account: '#(account)', stage: '#(stage)'}
    And header x-api-key = cart_x_api_key
    And header Content-Type = 'application/json'
    And request {"items":[{"lineItemId": 1,"itemId": '#(__arg.ItemId)', "shipToId" : '#(__arg.shipToId)'}]}
    When method patch
    Then status 200
    And print response
    And assert response.cartId == __arg.cartId
    And assert response.items[0].itemId == __arg.ItemId
    And assert response.items[0].shipTo.shipToId == __arg.shipToId
    And assert response.items[0].isActive == true


  @MultipleLineItem
  Scenario: Add shipTo for a cart
    Given path __arg.cartId + '/items/shipping-details'
    And header  x-site-context = {account: '#(account)', stage: '#(stage)'}
    And header x-api-key = cart_x_api_key
    And header Content-Type = 'application/json'
    And request {"items":[{"lineItemId": 1,"itemId": '#(__arg.ItemId1)', "shipToId" : '#(__arg.shipToId)'}, {"lineItemId": 2,"itemId": '#(__arg.ItemId2)', "shipToId" : '#(__arg.shipToId)'}]}
    When method patch
    Then status 200
    And print response
    And assert response.cartId == __arg.cartId
    And assert response.items[0].itemId == __arg.ItemId1
    And assert response.items[1].itemId == __arg.ItemId2
    And assert response.items[0].shipTo.shipToId == __arg.shipToId
    And assert response.items[1].shipTo.shipToId == __arg.shipToId
    And assert response.items[0].isActive == true
    And assert response.items[1].isActive == true

  @MultipleLineItemWithMultiShipping
  Scenario: Add shipTo for a cart
    Given path cartId + '/items/shipping-details'
    And header  x-site-context = {account: '#(account)', stage: '#(stage)'}
    And header x-api-key = cart_x_api_key
    And header Content-Type = 'application/json'
    * def addShipToCartToMultiShipIdBody = read('classpath:karate/core/cart/multiLineItemWithMultipleShipping.json')
    * addShipToCartToMultiShipIdBody.items[0].itemId = ItemId1
    * addShipToCartToMultiShipIdBody.items[1].itemId = ItemId
    * addShipToCartToMultiShipIdBody.items[0].shipToId = shipToId_1
    * addShipToCartToMultiShipIdBody.items[1].shipToId = shipToId_2
    And request addShipToCartToMultiShipIdBody
    When method patch
    Then status 200
    And print response
    And assert response.cartId == cartId
    And assert response.items[0].itemId == ItemId1
    And assert response.items[1].itemId == ItemId
    And assert response.items[0].shipTo.shipToId == shipToId_1
    And assert response.items[1].shipTo.shipToId == shipToId_2
    And assert response.items[0].isActive == true
    And assert response.items[1].isActive == true

  @SingleLineItemViaSKU
  Scenario: Add shipTo for a cart
    Given path  __arg.cartId + '/items/shipping-details'
    And header  x-site-context = {account: '#(account)', stage: '#(stage)'}
    And header x-api-key = cart_x_api_key
    And header Content-Type = 'application/json'
    And request {"items":[{"lineItemId": 1,"sku": '#(__arg.sku)', "shipToId" : '#(__arg.shipToId)'}]}
    When method patch
    Then status 200
    And print response
    And assert response.cartId == __arg.cartId
    And assert response.items[0].sku == __arg.sku
    And assert response.items[0].shipTo.shipToId == __arg.shipToId
    And assert response.items[0].isActive == true

  @MultipleLineItemViaSKU
  Scenario: Add shipTo for a cart
    Given path __arg.cartId + '/items/shipping-details'
    And header  x-site-context = {account: '#(account)', stage: '#(stage)'}
    And header x-api-key = cart_x_api_key
    And header Content-Type = 'application/json'
    And request {"items":[{"lineItemId": 1,"sku": '#(__arg.sku1)', "shipToId" : '#(__arg.shipToId)'}, {"lineItemId": 2,"sku": '#(__arg.sku2)', "shipToId" : '#(__arg.shipToId)'}]}
    When method patch
    Then status 200
    And print response
    And assert response.cartId == __arg.cartId
    And assert response.items[0].sku == __arg.sku1
    And assert response.items[1].sku == __arg.sku2
    And assert response.items[0].shipTo.shipToId == __arg.shipToId
    And assert response.items[1].shipTo.shipToId == __arg.shipToId
    And assert response.items[0].isActive == true
    And assert response.items[1].isActive == true