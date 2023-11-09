Feature: Cart Ship To

  Background:

    * def shipToRequestBody =  read('classpath:karate/core/cart/createShipTo.json')
    * def shipToRequestBodyBOPIS =  read('classpath:karate/core/cart/createShipToBopis.json')
    * shipToRequestBody.cartId = __arg.cartId
    * shipToRequestBodyBOPIS.cartId = __arg.cartId
    * shipToRequestBodyBOPIS.locationNum = __arg.locationNum
    * shipToRequestBody.shipMethod.shipMethodId = __arg.shippingMethodId
    * shipToRequestBody.shipMethod.cost.amount = __arg.shippingCost
    * def cart_x_api_key = cart_x_api_key
    * url cart_endpoint

@WEB_SHIP
  Scenario: Create shipTo for a cart
    Then print __arg
    Given path __arg.cartId + '/shipping-details'
    And header  x-site-context = {account: '#(account)', stage: '#(stage)'}
    And header x-api-key = cart_x_api_key
    And header Content-Type = 'application/json'
    And request shipToRequestBody
    When method post
    Then status 200
    And print response
    And assert response.shipToId != null && response.shipToId != ''
    And assert response.shipMethod.cost.amount == __arg.shippingCost
    And assert response.shipMethod.shipMethodId == __arg.shippingMethodId
    And assert response.shipToType == "SHIP_TO_ADDRESS"

@BOPIS
  Scenario: Create shipTo for a cart
    Then print __arg
    Given path __arg.cartId + '/shipping-details'
    And header  x-site-context = {account: '#(account)', stage: '#(stage)'}
    And header x-api-key = cart_x_api_key
    And header Content-Type = 'application/json'
    And request shipToRequestBodyBOPIS
    When method post
    Then status 200
    And print response
    And assert response.shipToId != null && response.shipToId != ''
    And assert response.isPickup ==  true
    And assert response.shipToType == "BOPIS"