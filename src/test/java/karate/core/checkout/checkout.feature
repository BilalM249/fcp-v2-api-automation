Feature: Checkout

  Background:

    * url checkout_endpoint
    * def checkoutRequestBody = read('classpath:karate/core/checkout/checkout.json')
    * def checkoutForMultiLineItemBody = read('classpath:karate/core/checkout/checkoutMultiLineItem.json')

    * def orderTotal = __arg.shippingCost +  __arg.cartTotal

    * checkoutRequestBody.cartId = __arg.cartId
    * checkoutRequestBody.estimatedTax.shipToTaxes[0].shipToId = __arg.shipToId
    * checkoutRequestBody.paymentDetails[0].amount = orderTotal

    * checkoutForMultiLineItemBody.cartId = __arg.cartId
    * checkoutForMultiLineItemBody.estimatedTax.shipToTaxes[0].shipToId = __arg.shipToId
    * checkoutForMultiLineItemBody.paymentDetails[0].amount = orderTotal



@CheckoutSingleLineItem
  Scenario: Checkout the cart
    Given path 'checkout'
    And header  x-site-context = {account: '#(account)', stage: '#(stage)'}
    And header Content-Type = 'application/json'
    And request checkoutRequestBody
    When method post
    Then status 200
    And assert response.checkoutComplete == true
    And assert response.orderId != null && response.orderId != ''

  @CheckoutMultipleLineItem
  Scenario: Checkout the cart
    Given path 'checkout'
    And header  x-site-context = {account: '#(account)', stage: '#(stage)'}
    And header Content-Type = 'application/json'
    And request checkoutForMultiLineItemBody
    When method post
    Then status 200
    And assert response.checkoutComplete == true
    And assert response.orderId != null && response.orderId != ''

  @CheckoutMultipleLineItemWithMultiShipId
  Scenario: Checkout the cart
    Given path 'checkout'
    And header  x-site-context = {account: '#(account)', stage: '#(stage)'}
    And header Content-Type = 'application/json'
    * def checkoutForMultiLineItemBodyWithMultiShipId = read('classpath:karate/core/checkout/checkoutMultiLineItemWithMultiShipId.json')
    * checkoutForMultiLineItemBodyWithMultiShipId.cartId = cartId
    * checkoutForMultiLineItemBodyWithMultiShipId.estimatedTax.shipToTaxes[0].shipToId = shipToId_1
    * checkoutForMultiLineItemBodyWithMultiShipId.estimatedTax.shipToTaxes[1].shipToId = shipToId_2
    * checkoutForMultiLineItemBodyWithMultiShipId.paymentDetails[0].amount = cartAmount
    And request checkoutForMultiLineItemBodyWithMultiShipId
    When method post
    Then status 200
    And assert response.checkoutComplete == true
    And assert response.orderId != null && response.orderId != ''

