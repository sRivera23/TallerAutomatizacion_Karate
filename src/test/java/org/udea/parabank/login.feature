@appcontact_login
Feature: Login to app contact

  Background:
    * url baseUrl
    * header Accept = 'application/json'

  Scenario: Customer Login
    Given path '/users/login'
    And request {"email": "karateP@gmail.com","password": "Karate123"}
    When method POST
    Then status 200
    And match response ==
    """
    {
    "user": {
        "_id": '#string',
        "firstName": '#string',
        "lastName": '#string',
        "email": '#string',
        "__v": '#number',
    },
    "token": '#string',
    }
    """
  Scenario: Login fallido con credenciales inválidas
  Given path '/users/login'
  And request { "email": "usuario-invalido@test.com", "password": "password-incorrecto" }
  When method POST
  Then status 401
  And match response == { error: '#string' }
