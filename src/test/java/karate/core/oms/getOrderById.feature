Feature: Get Order By Order ID

  Background:
    * url omsV2_endpoint
    * def orderId = __arg.orderId

    @GetOrderForSingleLineItem
  Scenario: Get Order By Order Id
    Given path 'order'
      And param orderId = orderId
    And header  x-site-context = {account: '#(account)', stage: '#(stage)'}
    And header Content-Type = 'application/json'
    And header Authorization = auth
    When method get
    Then status 200
    And print response
    And assert response.orderId == __arg.orderId
    And assert response.orderNumber != null && response.orderNumber != ''
    And assert response.statusCode == "ORDER_CREATED" || response.statusCode == "ORDER_HOLD" || response.statusCode == "ORDER_HOLD_CSR"
    And assert response.payments.length > 0
    And assert response.items.length == 1
    And assert response.items[0].type == "WEB_SHIP"


  @GetOrderForMultiLineItem
  Scenario: Get Order By Order Id
    Given path 'order'
    And param orderId = orderId
    And header  x-site-context = {account: '#(account)', stage: '#(stage)'}
    And header Content-Type = 'application/json'
    And header Authorization = auth
    When method get
    Then status 200
    And print response
    And assert response.orderId == __arg.orderId
    And assert response.orderNumber != null && response.orderNumber != ''
    And assert response.statusCode == "ORDER_CREATED" || response.statusCode == "ORDER_HOLD" || response.statusCode == "ORDER_HOLD_CSR"
    And assert response.payments.length > 0
    And assert response.items.length == 2
    And assert response.items[0].type == "WEB_SHIP"
    And assert response.items[1].type == "WEB_SHIP"

  @GetOrderForMultiLineItemForGiftWrap
  Scenario: Get Order By Order Id
    Given path 'order'
    And param orderId = orderId
    And header  x-site-context = {account: '#(account)', stage: '#(stage)'}
    And header Content-Type = 'application/json'
    And header Authorization = auth
    When method get
    Then status 200
    And print response
    And assert response.orderId == __arg.orderId
    And assert response.orderNumber != null && response.orderNumber != ''
    And assert response.statusCode == "ORDER_CREATED" || response.statusCode == "ORDER_HOLD" || response.statusCode == "ORDER_HOLD_CSR"
    And assert response.payments.length > 0
    And assert response.items.length == 2
    And assert response.items[0].attributes.isGift == true
    And assert response.items[1].attributes.isGift == true
    And assert response.items[0].type == "WEB_SHIP"
    And assert response.items[1].type == "WEB_SHIP"


  @GetOrderForMultiLineItemWithMultipleShipIdBOPIS
  Scenario: Get Order By Order Id
    Given path 'order'
    And param orderId = orderId
    And header  x-site-context = {account: '#(account)', stage: '#(stage)'}
    And header Content-Type = 'application/json'
    And header Authorization = auth
    When method get
    Then status 200
    And print response
    And assert response.orderId == __arg.orderId
    And assert response.orderNumber != null && response.orderNumber != ''
    And assert response.statusCode == "ORDER_CREATED" || response.statusCode == "ORDER_HOLD" || response.statusCode == "ORDER_HOLD_CSR"
    And assert response.payments.length > 0
    And assert response.items.length == 2
    And assert response.items[0].type == "WEB_PICKUP"
    And assert response.items[1].type == "WEB_PICKUP"

  @GetOrderForSingleLineItemBOPIS
  Scenario: Get Order By Order Id
    Given path 'order'
    And param orderId = orderId
    And header  x-site-context = {account: '#(account)', stage: '#(stage)'}
    And header Content-Type = 'application/json'
    And header Authorization = auth
    When method get
    Then status 200
    And print response
    And assert response.orderId == __arg.orderId
    And assert response.orderNumber != null && response.orderNumber != ''
    And assert response.statusCode == "ORDER_CREATED" || response.statusCode == "ORDER_HOLD" || response.statusCode == "ORDER_HOLD_CSR"
    And assert response.payments.length > 0
    And assert response.items.length == 1
    And assert response.items[0].type == "WEB_PICKUP"