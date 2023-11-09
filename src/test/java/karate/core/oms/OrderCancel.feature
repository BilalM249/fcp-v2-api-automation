Feature: Order Cancel and Partial Cancel

  Background:
    * url omsV2_endpoint
    * def fullOrderCancelBody = read('classpath:karate/core/oms/fullOrderCancel.json')
    * def partialOrderCancelBody = read('classpath:karate/core/oms/partialOrderCancel.json')
    * fullOrderCancelBody.orderId = __arg.orderId
    * partialOrderCancelBody.orderId = __arg.orderId
    * print partialOrderCancelBody.items[0].lineItemId
    * print __arg.lineItemId
    * partialOrderCancelBody.items[0].lineItemId = __arg.lineItemId

    @fullOrderCancel
  Scenario: Complete Order Cancel
    Given path   '/order/cancel'
    And header  x-site-context = {account: '#(account)', stage: '#(stage)'}
    And header Authorization = auth
    And header Content-Type = 'application/json'
    And request fullOrderCancelBody
    When method Post
    Then status 200
    Then print response
    And assert response.orderId == __arg.orderId
    And assert response.cartId == __arg.cartId
    And assert response.statusCode == "ORDER_CANCELLED"
    And assert response.payments[0].paymentIdentifier.paymentId == "cod"
    And assert response.payments[0].paymentProvider == "CASH_ON_DELIVERY"
    And assert response.payments[0].paymentStatus == "AUTHORIZED"
    And assert response.returns == null
    And assert response.items.length == 1
    And assert response.items[0].lineItemId == 1
    And assert response.items[0].itemId == __arg.ItemId
    And assert response.items[0].orderedQuantity == response.items[0].cancelledQuantity
    And assert response.shipInfo[0].shipToId == __arg.shipToId
    And assert response.cancellationDate != null


  @partialOrderCancel
  Scenario: Complete Order Cancel
    Given path   '/order/cancel'
    And header  x-site-context = {account: '#(account)', stage: '#(stage)'}
    And header Authorization = auth
    And header Content-Type = 'application/json'
    And request partialOrderCancelBody
    When method Post
    Then status 200
    Then print response
    And assert response.orderId == __arg.orderId
    And assert response.cartId == __arg.cartId
    And assert response.statusCode == "ORDER_PARTIALLY_CANCELLED"
    And assert response.payments[0].paymentIdentifier.paymentId == "cod"
    And assert response.payments[0].paymentProvider == "CASH_ON_DELIVERY"
    And assert response.payments[0].paymentStatus == "AUTHORIZED"
    And assert response.returns == null
    And assert response.items.length == 2
    And assert response.items[0].lineItemId == 1
    And assert response.items[0].itemId == __arg.ItemId1
    And assert response.items[0].orderedQuantity == response.items[0].cancelledQuantity
    And assert response.items[0].lineOrderStatus == "CANCELLED"

    And assert response.items[1].lineItemId == 2
    And assert response.items[1].itemId == __arg.ItemId2
    And assert response.items[1].orderedQuantity == 1
    And assert response.items[1].cancelledQuantity == 0
    And assert response.items[1].cancelledAmount == 0.00
    And assert response.shipInfo[0].shipToId == __arg.shipToId
    And assert response.cancellationDate != null