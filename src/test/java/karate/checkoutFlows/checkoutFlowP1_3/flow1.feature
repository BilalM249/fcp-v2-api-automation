
@Sanity
Feature: Item without Price
  Scenario: Add item to the cart without Price
    * def product  = call read('classpath:karate/core/pim/pim.feature@ForNonVariantItem') {ItemId : '#(Non_PriceItemId)'}
    * def ItemAttributes = product.response.products[0].attributes
    * def ItemId = product.response.products[0].itemId
    * def price  = call read('classpath:karate/core/price/price.feature@ForNon_PriceItem') {ItemId: '#(ItemId)'}
    * def sku = product.response.products[0].sku

    * def inventoryForItem  = call read('classpath:karate/core/inventory/inventory.feature@InventoryConfiguredItem') {sku : '#(sku)'}
    * def inventoryChannelForItem1 = inventoryForItem.response.inventory[0].channelId
    * def cart = call read('classpath:karate/core/cart/addToCart.feature@AddingNon_PriceItem') {ItemId: '#(ItemId)', ItemAttributes:'#(ItemAttributes)',InventoryChannelForItem1: '#(inventoryChannelForItem1)'}

