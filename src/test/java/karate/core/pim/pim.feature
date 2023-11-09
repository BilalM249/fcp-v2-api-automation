Feature: PIM / Capio Test

  Background:
    * url capio_endpoint
    * def ItemIds = __arg.ItemId

  @ForVariantItem
  Scenario: Get product by itemID

    Given path 'product'
    And header x-site-context = {account: '#(account)', stage: '#(stage)'}
    And param itemIds = '['+ItemIds+']'
    When method get
    Then status 200
    And print response
    And print response.products[0]
    And assert response.products[0].sku != null && response.products[0].sku != ''
   # And assert response.products[0].sku == '#(variant_Item_Sku)'
    And assert response.products[0].children.length ==2
    #And assert response.products[0].children[0].sku== "TESTSKUBLACK"
    #And assert response.products[0].children[1].sku == "TESTSKURED"
    #And assert response.products[0].children[1].attributes[2].value == "Red"
    #And assert response.products[0].children[0].attributes[2].value == "Black"


  @ForNonVariantItem
  Scenario: Get product by itemID

    Given path 'product'
    And header x-site-context = {account: '#(account)', stage: '#(stage)'}
    And param itemIds = '['+ItemIds+']'
    When method get
    Then status 200
    And print response
    And print response.products[0]
    And assert response.products[0].sku != null && response.products[0].sku != ''
    #And assert response.products[0].sku == '#(non_variant_Item_Sku)'
    And assert response.products[0].children.length ==0


    @ForBundleItem
    Scenario: Get product by itemID
      Given path 'product'
      And header x-site-context = {account: '#(account)', stage: '#(stage)'}
      And param itemIds = '['+ItemIds+']'
      When method get
      Then status 200
      And print response
      And print response.products[0]
      And assert response.products[0].sku != null && response.products[0].sku != ''
      And assert response.products[0].children.length == 0
      #And assert response.products[0].bundleItems.length == 4
      And assert response.products[0].type == "BUNDLE"
      And assert response.products[0].status == true

