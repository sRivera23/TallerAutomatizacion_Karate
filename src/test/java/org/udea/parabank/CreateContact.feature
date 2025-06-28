@appcontact_createcontact
Feature: create contact to app contact

  Background:
    * url baseUrl
    * header Accept = 'application/json'

  Scenario: Login exitoso
    Given path '/users/login'
    And request
    """
    { "email": "karateP@gmail.com", "password": "Karate123" }
    """
    When method POST
    Then status 200
    * def authToken = response.token

  Scenario: Crear contacto exitoso y verificarlo vía API
    # Login
    Given path '/users/login'
    And request
    """
    { "email": "karateP@gmail.com", "password": "Karate123" }
    """
    When method POST
    Then status 200
    * def authToken = response.token

    # Crear contacto
    * def emailValue = 'prueba.' + java.util.UUID.randomUUID() + '@mail.com'
    Given path '/contacts'
    And header Authorization = 'Bearer ' + authToken
    And request
    """
    {
      "firstName": "Prueba",
      "lastName": "UDEA",
      "birthdate": "1970-01-01",
      "email": "#(emailValue)",
      "phone": "8005555555",
      "street1": "1 Main St.",
      "street2": "Apartment A",
      "city": "Anytown",
      "stateProvince": "KS",
      "postalCode": "12345",
      "country": "USA"
    }
    """
    When method POST
    Then status 201

    # Verificar que aparece en /contacts
    Given path '/contacts'
    And header Authorization = 'Bearer ' + authToken
    When method GET
    Then status 200
    And match response[*].email contains emailValue

  Scenario: No debe permitir contacto sin firstName
    # Login
    Given path '/users/login'
    And request
    """
    { "email": "karateP@gmail.com", "password": "Karate123" }
    """
    When method POST
    Then status 200
    * def authToken = response.token

    # Crear contacto sin firstName
    Given path '/contacts'
    And header Authorization = 'Bearer ' + authToken
    And request
    """
    {
      "lastName": "SinNombre",
      "email": "contacto.sin.nombre@mail.com",
      "phone": "8001112233"
    }
    """
    When method POST
    Then status 400
    And match response.errors.firstName != null

  Scenario: No debe permitir contactos con email duplicado
    # Login
    Given path '/users/login'
    And request
    """
    { "email": "karateP@gmail.com", "password": "Karate123" }
    """
    When method POST
    Then status 200
    * def authToken = response.token
    * def reusedEmail = 'duplicado@mail.com'

    # Primer contacto
    Given path '/contacts'
    And header Authorization = 'Bearer ' + authToken
    And request
    """
    {
      "firstName": "Original",
      "lastName": "Original",
      "email": "#(reusedEmail)"
    }
    """
    When method POST
    Then status 201

    # Intentar crear otro con el mismo email
    Given path '/contacts'
    And header Authorization = 'Bearer ' + authToken
    And request
    """
    {
      "firstName": "Duplicado",
      "lastName": "Duplicado",
      "email": "#(reusedEmail)"
    }
    """
    When method POST
    Then status 400
    And match response.message contains "duplicate"

