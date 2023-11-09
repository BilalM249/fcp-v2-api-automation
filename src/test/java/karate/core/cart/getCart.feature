Feature: Get Cart By Cart ID

  Background:

    * url cart_endpoint
    * def cart_x_api_key = cart_x_api_key
    * def cartId = __arg.cartID
    * print cartId

  @GetPromotionalShippingCart
  Scenario: Get Cart By Cart ID
    Given path cartId
    And header  x-site-context = {account: '#(account)', stage: '#(stage)'}
    And header x-api-key = cart_x_api_key
    And header Content-Type = 'application/json'
    When method get
    Then status 200
    And print response
    And assert response.cartId != null && response.cartId != ''
    And assert response.cartState == 'PENDING'
    And assert response.allPromosApplied.length > 0
    And assert response.subTotal == response.totalAmount + response.totalDiscount
    And assert response.items[0].totalPrice.amount == response.items[0].totalPrice.sale
    And assert response.items[0].totalPrice.discount.discounts.length > 0
    And assert response.items[0].totalPrice.amount == response.items[0].totalPrice.sale + response.items[0].totalPrice.discount.discountAmount
    And assert response.items[0].totalPrice.discount.discounts[0].type == "SHIPPING"

  @GetCartWithSingleItemAndFreeShipping
  Scenario: Get Cart By Cart ID
    Given path cartId
    And header  x-site-context = {account: '#(account)', stage: '#(stage)'}
    And header x-api-key = cart_x_api_key
    And header Content-Type = 'application/json'
    When method get
    Then status 200
    And print response
    And assert response.cartId != null && response.cartId != ''
    And assert response.cartState == 'PENDING'
    And assert response.items[0].shipTo.shipMethod.cost.amount == 0
    And assert response.subTotal == response.totalAmount + response.totalDiscount
    And assert response.items[0].totalPrice.amount == response.items[0].totalPrice.sale

  @GetCartWithMultiLineItem
  Scenario: Get Cart By Cart ID
    Given path cartId
    And header  x-site-context = {account: '#(account)', stage: '#(stage)'}
    And header x-api-key = cart_x_api_key
    And header Content-Type = 'application/json'
    When method get
    Then status 200
    And print response
    And assert response.cartId != null && response.cartId != ''
    And assert response.cartState == 'PENDING'
    And assert response.items[0].cartItemId != "" && response.items[0].cartItemId != null
    And assert response.items[0].sku != "" && response.items[0].sku != null
    And assert response.items[0].itemId != "" && response.items[0].itemId != null
    And assert response.items[1].cartItemId != "" && response.items[1].cartItemId != null
    And assert response.items[1].sku != "" && response.items[1].sku != null
    And assert response.items[1].itemId != "" && response.items[1].itemId != null
    And assert response.items[0].shipTo.shipMethod.cost.amount == 10
    And assert response.items[0].totalPrice.amount == response.items[0].unitPrice.amount * response.items[0].quantity
    And assert response.items[1].totalPrice.amount == response.items[1].unitPrice.amount * response.items[1].quantity