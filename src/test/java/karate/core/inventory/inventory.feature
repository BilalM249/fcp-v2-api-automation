Feature: Inventory v2

  Background:

    * url omsV2_endpoint

    @InventoryConfiguredItem
  Scenario: Get Inventory by SKU and network Code
    Given path 'inventory'
    And param networkCodes = 'ShipToHome'
    And param skus = __arg.sku
    And header x-site-context = {account: '#(account)', stage: '#(stage)'}
    And header Authorization = auth
    When method get
    Then status 200
    And print response
    And assert response.inventory.length >0
    And assert response.inventory[0].virtualCounters.availableToPurchase > 0


  @ForNon_InventoryItem
  Scenario: Get Inventory by SKU and network Code
    Given path 'inventory'
    And param networkCodes = 'ShipToHome'
    And param skus = __arg.sku
    And header x-site-context = {account: '#(account)', stage: '#(stage)'}
    And header Authorization = auth
    When method get
    Then status 200
    And print response
    And response.pagination.inventory = null


  @InventoryConfiguredItemForBOPIS
  Scenario: Get Inventory by SKU and network Code
    Given path 'inventory'
    And param channels = __arg.channels
    And param skus = __arg.sku
    And header x-site-context = {account: '#(account)', stage: '#(stage)'}
    And header Authorization = auth
    When method get
    Then status 200
    And print response
    And assert response.inventory.length >0
    And assert response.inventory[0].virtualCounters.availableToPurchase > 0
    And assert response.inventory[0].locationNum != null

