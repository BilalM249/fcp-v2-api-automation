Feature: Add Coupon To Cart

  Background:
    * url cart_endpoint
    * def cart_x_api_key = cart_x_api_key

  @SingleLineItem
  Scenario: apply coupon to cart
    Given path  __arg.cartId + '/promos/' + __arg.couponCode
    And header  x-site-context = {account: '#(account)', stage: '#(stage)'}
    And header x-api-key = cart_x_api_key
    And header Content-Type = 'application/json'
    When method post
    Then status 200
    And assert response.items[0].totalPrice.discount.promosApplied.length > 0
    And assert response.items[0].totalPrice.discount.promosApplied[0].promoCode ==  __arg.couponCode.toUpperCase()
    And assert response.items[0].totalPrice.discount.discounts.length > 0
    And assert response.items[0].totalPrice.discount.discounts[0].promoCode ==   __arg.couponCode.toUpperCase()
    And assert response.items[0].totalPrice.discount.discounts.length > 0
    And assert response.items[0].totalPrice.discount.discounts[0].promoCode ==   __arg.couponCode.toUpperCase()
    And assert response.items[0].totalPrice.amount == response.items[0].totalPrice.sale +  response.items[0].totalPrice.discount.discountAmount

    And assert response.allPromosApplied.length > 0
    And assert response.allPromosApplied[0].promoCode ==  __arg.couponCode.toUpperCase()
    * def subTotal =  response.subTotal
    * def totalAmount =  response.totalAmount
    * def totalDiscount = response.totalDiscount
    And assert subTotal == totalDiscount + totalAmount


  @MultiLineItem
  Scenario: apply coupon to cart
    Given path  __arg.cartId + '/promos/' + __arg.couponCode
    And header  x-site-context = {account: '#(account)', stage: '#(stage)'}
    And header x-api-key = cart_x_api_key
    And header Content-Type = 'application/json'
    When method post
    Then status 200
    And assert response.items[0].totalPrice.discount.promosApplied.length > 0
    And assert response.items[0].totalPrice.discount.promosApplied[0].promoCode ==  __arg.couponCode.toUpperCase()
    And assert response.items[0].totalPrice.discount.discounts.length > 0
    And assert response.items[0].totalPrice.discount.discounts[0].promoCode ==   __arg.couponCode.toUpperCase()
    And assert response.items[0].totalPrice.discount.discounts.length > 0
    And assert response.items[0].totalPrice.discount.discounts[0].promoCode ==   __arg.couponCode.toUpperCase()
    And assert response.items[0].totalPrice.amount == response.items[0].totalPrice.sale +  response.items[0].totalPrice.discount.discountAmount
    And assert response.allPromosApplied.length > 0
    And assert response.allPromosApplied[0].promoCode ==  __arg.couponCode.toUpperCase()

    And assert response.items[1].totalPrice.amount == response.items[1].unitPrice.amount * response.items[1].quantity
    And assert response.items[1].totalPrice.sale == response.items[1].unitPrice.sale * response.items[1].quantity
    And assert response.items[1].totalPrice.discount.discountAmount ==  0

    * def subTotal =  response.subTotal
    * def totalAmount =  response.totalAmount
    * def totalDiscount = response.totalDiscount
    And assert subTotal == totalDiscount + totalAmount



  @ShippingCouponWithSingleLineItem
  Scenario: apply coupon to cart
    Given path  __arg.cartId + '/promos/' + __arg.couponCode
    And header  x-site-context = {account: '#(account)', stage: '#(stage)'}
    And header x-api-key = cart_x_api_key
    And header Content-Type = 'application/json'
    When method post
    Then status 200
    And assert response.items[0].totalPrice.discount.promosApplied.length > 0
    And assert response.items[0].totalPrice.discount.promosApplied[0].promoCode ==  __arg.couponCode.toUpperCase()
    And assert response.items[0].totalPrice.discount.discounts.length > 0
    And assert response.items[0].totalPrice.discount.discounts[0].promoCode ==   __arg.couponCode.toUpperCase()
    And assert response.items[0].totalPrice.discount.discounts.length > 0
    And assert response.items[0].totalPrice.discount.discounts[0].promoCode ==   __arg.couponCode.toUpperCase()
    And assert response.items[0].totalPrice.amount == response.items[0].totalPrice.sale +  response.items[0].totalPrice.discount.discountAmount
    And assert response.items[0].shipTo.shipMethod.cost.discount == 10
    And assert response.allPromosApplied.length > 0
    And assert response.allPromosApplied[0].promoCode ==  __arg.couponCode.toUpperCase()
    * def subTotal =  response.subTotal
    * def totalAmount =  response.totalAmount
    * def totalDiscount = response.totalDiscount
    And assert subTotal == totalDiscount + totalAmount


  @ShippingCouponOnAFreeShippingCart
  Scenario: apply coupon to cart
    Given path  __arg.cartId + '/promos/' + __arg.couponCode
    And header  x-site-context = {account: '#(account)', stage: '#(stage)'}
    And header x-api-key = cart_x_api_key
    And header Content-Type = 'application/json'
    When method post
    Then status 404
    And assert response.code == "PROMO_NOT_APPLICABLE_ERROR"
    And assert response.description == "Promo not applicable for given item."
    And assert response.details[0].code == "PROMO_NOT_APPLICABLE_ERROR"
    And match response.details[0].detail contains "cannot get shipping discounts because shipping is already $0.0 for this item"


  @ApplyingExpiredCoupon
  Scenario: apply coupon to cart
    Given path  __arg.cartId + '/promos/' + __arg.couponCode
    And header  x-site-context = {account: '#(account)', stage: '#(stage)'}
    And header x-api-key = cart_x_api_key
    And header Content-Type = 'application/json'
    When method post
    Then status 404
    And assert response.code == "PROMO_NOT_APPLICABLE_ERROR"
    And assert response.description == "Promo not applicable for given item."
    And assert response.details[0].code == "PROMO_NOT_APPLICABLE_ERROR"
    And match response.details[0].detail contains "Invalid coupon."


    @ApplyingMultiTierCoupon
    Scenario: apply coupon to cart
      Given path  __arg.cartId + '/promos/' + __arg.couponCode
      And header  x-site-context = {account: '#(account)', stage: '#(stage)'}
      And header x-api-key = cart_x_api_key
      And header Content-Type = 'application/json'
      When method post
      Then status 200
      And assert response.items[0].totalPrice.discount.promosApplied[0].promoCode ==  __arg.couponCode.toUpperCase()
      And assert response.items[0].totalPrice.discount.discounts.length > 0
      And assert response.items[0].totalPrice.discount.discounts[0].type == "QUANTITY"
      And assert response.items[0].totalPrice.discount.discounts[0].amount == 10
      And assert response.totalAmount == response.items[0].totalPrice.sale + response.items[1].totalPrice.sale


  @MultiLineAllCLRItem
  Scenario: apply coupon to cart
    Given path  __arg.cartId + '/promos/' + __arg.couponCode
    And header  x-site-context = {account: '#(account)', stage: '#(stage)'}
    And header x-api-key = cart_x_api_key
    And header Content-Type = 'application/json'
    When method post
    Then status 200
    And assert response.items[0].totalPrice.discount.promosApplied.length > 0
    And assert response.items[0].totalPrice.discount.promosApplied[0].promoCode ==  __arg.couponCode.toUpperCase()
    And assert response.items[0].totalPrice.discount.discounts.length > 0
    And assert response.items[0].totalPrice.discount.discounts[0].promoCode ==   __arg.couponCode.toUpperCase()
    And assert response.items[0].totalPrice.amount == response.items[0].totalPrice.sale +  response.items[0].totalPrice.discount.discountAmount


    And assert response.items[1].totalPrice.discount.promosApplied.length > 0
    And assert response.items[1].totalPrice.discount.promosApplied[0].promoCode ==  __arg.couponCode.toUpperCase()
    And assert response.items[1].totalPrice.discount.discounts.length > 0
    And assert response.items[1].totalPrice.discount.discounts[0].promoCode ==   __arg.couponCode.toUpperCase()
    And assert response.items[1].totalPrice.amount == response.items[1].totalPrice.sale +  response.items[1].totalPrice.discount.discountAmount

    And assert response.allPromosApplied.length > 0
    And assert response.allPromosApplied[0].promoCode ==  __arg.couponCode.toUpperCase()

    And assert response.items[1].totalPrice.amount == response.items[1].unitPrice.amount * response.items[1].quantity
    And assert response.items[1].totalPrice.sale == response.items[1].unitPrice.sale - (response.items[1].quantity * response.items[1].totalPrice.discount.discountAmount)
    And assert response.items[1].totalPrice.discount.discountAmount >  0

    * def subTotal =  response.subTotal
    * def totalAmount =  response.totalAmount
    * def totalDiscount = response.totalDiscount
    And assert subTotal == totalDiscount + totalAmount

  @SingleLineItemUsedCoupon
  Scenario: apply coupon to cart
    Given path  __arg.cartId + '/promos/' + __arg.couponCode
    And header  x-site-context = {account: '#(account)', stage: '#(stage)'}
    And header x-api-key = cart_x_api_key
    And header Content-Type = 'application/json'
    When method post
    Then status 404
    And assert response.code == "PROMO_NOT_APPLICABLE_ERROR"
    And assert response.details[0].code == "PROMO_NOT_APPLICABLE_ERROR"
    And assert response.details[0].detail == "Sitewide limit of 1 uses has been reached."