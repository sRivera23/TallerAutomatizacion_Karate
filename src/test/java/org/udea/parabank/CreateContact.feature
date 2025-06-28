@appcontact_createcontact
Feature: create contact to app contact

  Background:
    * url baseUrl
    * header Accept = 'application/json'
Scenario: Login y crear contacto
  # Login
  Given path '/users/login'
  And request { "email": "karateP@gmail.com", "password": "Karate123" }
  When method POST
  Then status 200
  * def authToken = response.token

  # Crear contacto
  Given path '/contacts'
  And header Authorization = 'Bearer ' + authToken
  And request { "firstName": "messi", "lastName": "ronaldo", "birthdate": "1975-01-01", "email": "ronaldomessi@fake.com", "phone": "8006555555", "street1": "1 Main St.", "street2": "Apartment A", "city": "Anytown", "stateProvince": "KS", "postalCode": "12345", "country": "USA" }
  When method POST
  Then status 201
