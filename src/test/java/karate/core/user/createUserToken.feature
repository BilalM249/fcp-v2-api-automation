Feature: Sending OAuth2 token request for Stg02

  @stg02
  Scenario: Get OAuth2 token
    Given url 'https://internalstg-internalfcpstg.login-stg.fabric.inc/oauth2/default/v1/token'
    And header accept = 'application/json'
    And header Content-Type = 'application/x-www-form-urlencoded'
    And header Cookie = 'DT=DI1LLIdvjsRTCW-J_2ueyWQ1A; JSESSIONID=05179174C5A7F9F8E627FB1EB1061FF2; JSESSIONID=B39C70E82FB0D669EE12C442A3D10E4B'
    And form field grant_type = 'password'
    And form field username = 'shivam+1@fabric.inc'
    And form field password = 'Password@1234'
    And form field client_id = '0oa85l80lwG2Ap59T1d7'
    And form field client_secret = 'KVabhAoYSj7lYjF3YO7qAZUo5aCe02Yy34zLECmB'
    And form field scope = 'openid email offline_access'
    When method POST
    Then status 200
    And print response
    And assert response.token_type == "Bearer"
    And assert response.expires_in == "3600"
    And assert response.access_token != null && response.access_token != ''

  @prod
  Scenario: Get OAuth2 token
    Given url 'https://internalprod-internalfcpqa.login.fabric.inc/oauth2/default/v1/token'
    And header accept = 'application/json'
    And header Content-Type = 'application/x-www-form-urlencoded'
    And header Cookie = 'DT=DI1LLIdvjsRTCW-J_2ueyWQ1A; JSESSIONID=05179174C5A7F9F8E627FB1EB1061FF2; JSESSIONID=B39C70E82FB0D669EE12C442A3D10E4B'
    And form field grant_type = 'password'
    And form field username = 'shivam+1@fabric.inc'
    And form field password = 'Password@1234'
    And form field client_id = '0oa5jgd7pq4xDNpSM697'
    And form field client_secret = 'R2AdEnKhMXKQCPXAAUh4S7hVRGSw5Gu5r2wiUiWr'
    And form field scope = 'openid email offline_access'
    When method POST
    Then status 200
    And print response
    And assert response.token_type == "Bearer"
    And assert response.expires_in == "3600"
    And assert response.access_token != null && response.access_token != ''

  @sandbox
  Scenario: Get OAuth2 token
    Given url 'https://fabricse01sandbox.login-sbx.fabric.inc/oauth2/default/v1/token'
    And header accept = 'application/json'
    And header Content-Type = 'application/x-www-form-urlencoded'
    And header Cookie = 'DT=DI1LLIdvjsRTCW-J_2ueyWQ1A; JSESSIONID=05179174C5A7F9F8E627FB1EB1061FF2; JSESSIONID=B39C70E82FB0D669EE12C442A3D10E4B'
    And form field grant_type = 'password'
    And form field username = 'shivam+2@fabric.inc'
    And form field password = 'Password@1234'
    And form field client_id = '0oa5jfy38z1JR68x9697'
    And form field client_secret = 'TleTIbzMoKbXYFLBrMddmgwffXywz1vChCVKGf_O'
    And form field scope = 'openid email offline_access'
    When method POST
    Then status 200
    And print response
    And assert response.token_type == "Bearer"
    And assert response.expires_in == "3600"
    And assert response.access_token != null && response.access_token != ''
