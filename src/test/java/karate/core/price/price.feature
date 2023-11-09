Feature: Price v2 RTPE


  Background:
    * url rtpe_endpoint
    * def priceListId = PRICE_LIST_ID
    * def payload = {"priceList": ['#(priceListId)'], "itemId": ['#(__arg.ItemId1)','#(__arg.ItemId2)']}
  @PriceFor2Items
  Scenario: Get Price
    Given path 'get-by-sku'
    And header x-site-context = {account: '#(account)', stage: '#(stage)'}
    And header Content-type = 'application/json'
    And request payload
    And header Authorization = auth
    When method post
    Then status 200
    And print response
    And assert response.length == 2
    And assert response[0].offers.price.base != null &&  response[0].offers.price.base != ''
    And assert response[1].offers.price.base != null &&  response[1].offers.price.base != ''

  @PriceForSingleItems
  Scenario: Get Price
    Given path 'get-by-sku'
    And header x-site-context = {account: '#(account)', stage: '#(stage)'}
    And header Content-type = 'application/json'
    And request {"priceList": ['#(priceListId)'], "itemId": ['#(__arg.ItemId)']}
    And header Authorization = auth
    When method post
    Then status 200
    And print response
    And assert response.length == 1
    And assert response[0].offers.price.base != null &&  response[0].offers.price.base != ''

  @ForNon_PriceItem
  Scenario: Get Price
    Given path 'get-by-sku'
    And header x-site-context = {account: '#(account)', stage: '#(stage)'}
    And header Content-type = 'application/json'
    And request {"priceList": ['#(priceListId)'], "itemId": ['#(__arg.ItemId)']}
    And header Authorization = auth
    When method post
    Then status 200
    And print response
    And assert response[0].sku ==  null
    And assert response[0].itemId ==  __arg.ItemId
    And assert response[0].errorCode ==  404
    And assert response[0].tag ==  null

    @ClearancePriceForSingleItem
    Scenario: Get Price
      Given path 'get-by-sku'
      And header x-site-context = {account: '#(account)', stage: '#(stage)'}
      And header Content-type = 'application/json'
      And request {"priceList": ['#(priceListId)'], "itemId": ['#(__arg.ItemId)']}
      And header Authorization = auth
      When method post
      Then status 200
      And print response
      And assert response.length == 1
      And assert response[0].offers.price.base != null &&  response[0].offers.price.base != ''
      And assert response[0].offers.price.sale != null &&  response[0].offers.price.sale != ''
      And assert response[0].offers.kind == "SALE"

  @ClearancePriceFor2Items
  Scenario: Get Price
    Given path 'get-by-sku'
    And header x-site-context = {account: '#(account)', stage: '#(stage)'}
    And header Content-type = 'application/json'
    And request payload
    And header Authorization = auth
    When method post
    Then status 200
    And print response
    And assert response.length == 2
    And assert response[0].offers.price.base != null &&  response[0].offers.price.base != ''
    And assert response[1].offers.price.base != null &&  response[1].offers.price.base != ''
    And assert response[0].offers.price.sale != null &&  response[0].offers.price.sale != ''
    And assert response[1].offers.price.sale != null &&  response[1].offers.price.sale != ''
    And assert response[0].offers.kind == "SALE"
    And assert response[1].offers.kind == "SALE"