@Sanity
Feature: Variant item without Inventory
  Scenario: Add item to the cart without Inventory
    * def product  = call read('classpath:karate/core/pim/pim.feature@ForVariantItem') {ItemId : '#(Non_InventoryItemId)'}
    * def ItemId1 = product.response.products[0].children[0].itemId
    * def ItemId2 = product.response.products[0].children[1].itemId
    * def ItemId1Attributes = product.response.products[0].children[0].attributes
    * def price  = call read('classpath:karate/core/price/price.feature@PriceFor2Items') {ItemId1: '#(ItemId1)', ItemId2: '#(ItemId2)'}
    * def sku1 = product.response.products[0].children[0].sku
    * def sku2 = product.response.products[0].children[1].sku
    * def inventoryForItem1  = call read('classpath:karate/core/inventory/inventory.feature@ForNon_InventoryItem') {sku : '#(sku1)'}
    * def inventoryForItem2  = call read('classpath:karate/core/inventory/inventory.feature@ForNon_InventoryItem') {sku : '#(sku2)'}

    * def cart = call read('classpath:karate/core/cart/addToCart.feature@AddingNon_InventoryItem') {ItemId: '#(ItemId1)', ItemAttributes:'#(ItemId1Attributes)',InventoryChannelForItem1: 12}

