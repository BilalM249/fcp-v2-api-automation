@Sanity
Feature: Checkout with Bundle product Along with expired coupon

  Scenario: EXPIRED_COUPON Coupon Applied to Cart with Bundle Item
    * def product  = call read('classpath:karate/core/pim/pim.feature@ForBundleItem') {ItemId : '#(Bundle_ItemId)'}
    * def ItemAttributes = product.response.products[0].attributes
    * def ItemId = product.response.products[0].itemId
    * def sku = product.response.products[0].sku
    * def price  = call read('classpath:karate/core/price/price.feature@PriceForSingleItems') {ItemId: '#(ItemId)'}

    * def inventoryForItem  = call read('classpath:karate/core/inventory/inventory.feature@InventoryConfiguredItem') {sku : '#(sku)'}
    * def inventoryChannelForItem1 = inventoryForItem.response.inventory[0].channelId
    * def cart = call read('classpath:karate/core/cart/addToCart.feature@AddingSingleItemToCart') {ItemId: '#(ItemId)', ItemAttributes:'#(ItemAttributes)',InventoryChannelForItem1: '#(inventoryChannelForItem1)'}
    * def cartId = cart.response.cartId
    * def applyCoupon = call read('classpath:karate/core/cart/applyCoupon.feature@ApplyingExpiredCoupon') {cartId: '#(cartId)', couponCode:'#(Expired_Coupon)'}
