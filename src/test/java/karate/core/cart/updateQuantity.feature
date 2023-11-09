Feature: update Cart Quantity

  Background:

    * url cart_endpoint
    * def cart_x_api_key = cart_x_api_key

  @UpdateQtyForSingleLineItem
  Scenario: Add to Cart
    Given path __arg.cartId + '/items'
    And header  x-site-context = {account: '#(account)', stage: '#(stage)'}
    And header x-api-key = cart_x_api_key
    And header Content-Type = 'application/json'
    And request {"cartId":"#(__arg.cartId)" ,"items":[{"lineItemId":1,"quantity":"#(__arg.Quantity)","itemId":"#(__arg.ItemId)"}]}
    When method PATCH
    Then status 200
    And print response
    And assert response.cartId != null && response.cartId != ''
    And assert response.cartState == 'PENDING'
    And assert response.items[0].quantity == __arg.Quantity
    * def unitPrice = response.items[0].unitPrice.sale
    * def totalAmount = response.totalAmount
    And assert response.totalAmount == response.items[0].unitPrice.sale * __arg.Quantity



  @UpdateQtyForMultiLineItemAndMultiTierQuantityCoupon
  Scenario: Add to Cart
    Given path __arg.cartId + '/items'
    And header  x-site-context = {account: '#(account)', stage: '#(stage)'}
    And header x-api-key = cart_x_api_key
    And header Content-Type = 'application/json'
    And request {"cartId":"#(__arg.cartId)" ,"items":[{"lineItemId":1,"quantity":"#(__arg.Quantity)","itemId":"#(__arg.ItemId)"}]}
    When method PATCH
    Then status 200
    And print response
    And assert response.cartId != null && response.cartId != ''
    And assert response.cartState == 'PENDING'
    And assert response.items[0].quantity == __arg.Quantity
    * def unitPrice = response.items[0].unitPrice.sale
    * def totalAmount = response.totalAmount
    And assert response.totalAmount == response.items[0].totalPrice.sale + response.items[1].totalPrice.sale
    And assert response.items[0].totalPrice.discount.discounts[0].value == 20
    And assert response.items[0].totalPrice.discount.discounts[0].quantity == 2
    And assert response.items[0].totalPrice.discount.discounts[0].type == "QUANTITY"
    And assert response.items[0].totalPrice.sale == response.items[0].totalPrice.amount - response.items[0].totalPrice.discount.discountAmount
    And assert response.items[0].totalPrice.discount.discountAmount == ( response.items[0].totalPrice.discount.discounts[0].value / 100 ) * response.items[0].totalPrice.amount

