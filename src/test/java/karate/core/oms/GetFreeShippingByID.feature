Feature: Get Ship To

  Background:
    * def shippingId = __arg.shippingId
    * url omsV2_endpoint

@free_shipping
Scenario: Get Shipping Method Details
Given path  'shipping/' + shippingId
And header  x-site-context = {account: '#(account)', stage: '#(stage)'}
And header Authorization = auth
And header Content-Type = 'application/json'
When method Get
Then status 200
And print response
And assert response.name == 'FedEx Free'
And assert response.description == 'FedEx free shipping!'
And assert response.taxCode == 'FR02000'