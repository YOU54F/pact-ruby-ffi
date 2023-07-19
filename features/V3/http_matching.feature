Feature: Matching HTTP parts (request or response)

  Scenario: Comparing content type headers which are equal
    Given an expected request with a "content-type" header of "application/json"
    And a request is received with a "content-type" header of "application/json"
    When the request is compared to the expected one
    Then the comparison should be OK

  Scenario: Comparing content type headers where they have the same charset
    Given an expected request with a "content-type" header of "application/json;charset=UTF-8"
    And a request is received with a "content-type" header of "application/json;charset=utf-8"
    When the request is compared to the expected one
    Then the comparison should be OK

  Scenario: Comparing content type headers where the actual has a charset
    Given an expected request with a "content-type" header of "application/json"
    And a request is received with a "content-type" header of "application/json;charset=UTF-8"
    When the request is compared to the expected one
    Then the comparison should be OK

  Scenario: Comparing content type headers where the actual is missing a charset
    Given an expected request with a "content-type" header of "application/json;charset=UTF-8"
    And a request is received with a "content-type" header of "application/json"
    When the request is compared to the expected one
    Then the comparison should NOT be OK
    And the mismatches will contain a mismatch with error "content-type" -> "Expected header content-type to have value 'application/json;charset=UTF-8' but was 'application/json'"

  Scenario: Comparing content type headers where the actual has a different charset
    Given an expected request with a "content-type" header of "application/json;charset=UTF-16"
    And a request is received with a "content-type" header of "application/json;charset=UTF-8"
    When the request is compared to the expected one
    Then the comparison should NOT be OK
    And the mismatches will contain a mismatch with error "content-type" -> "Expected header content-type to have value 'application/json;charset=UTF-16' but was 'application/json;charset=UTF-8'"

  Scenario: Comparing accept headers where the actual has additional parameters
    Given an expected request with an "accept" header of "text/html, application/xhtml+xml, application/xml, image/webp, */*"
    And a request is received with an "accept" header of "text/html, application/xhtml+xml, application/xml;q=0.9, image/webp, */*;q=0.8"
    When the request is compared to the expected one
    Then the comparison should be OK

  Scenario: Comparing accept headers where the actual has is missing a value
    Given an expected request with an "accept" header of "text/html, application/xhtml+xml, application/xml, image/webp, */*"
    And a request is received with an "accept" header of "text/html, application/xml;q=0.9, image/webp, */*;q=0.8"
    When the request is compared to the expected one
    Then the comparison should NOT be OK

  Scenario: Supports an equality matcher to reset cascading rules
    Given an expected request configured with the following:
      | body               | matching rules                 |
      | file: 3-level.json | equality-matcher-reset-v3.json |
    And a request is received with the following:
      | body                                                                                                        |
      | JSON: { "one": { "a": { "ids": [100], "status": "Lovely" }  }, "two": [ { "ids": [1], "status": "BAD" } ] } |
    When the request is compared to the expected one
    Then the comparison should NOT be OK
    And the mismatches will contain a mismatch with error "$.one.a.status" -> "Expected 'Lovely' (String) to equal 'OK' (String)"

  Scenario: Supports an include matcher (positive case)
    Given an expected request configured with the following:
      | body             | matching rules          |
      | file: basic.json | include-matcher-v3.json |
    And a request is received with the following:
      | body                               |
      | JSON: { "one": "cat", "two": "b" } |
    When the request is compared to the expected one
    Then the comparison should be OK

  Scenario: Supports an include matcher (negative case)
    Given an expected request configured with the following:
      | body             | matching rules          |
      | file: basic.json | include-matcher-v3.json |
    And a request is received with the following:
      | body                               |
      | JSON: { "one": "dog", "two": "b" } |
    When the request is compared to the expected one
    Then the comparison should NOT be OK
    And the mismatches will contain a mismatch with error "$.one" -> "Expected 'dog' to include 'a'"

  Scenario: Supports an include matcher (positive case)
    Given an expected request configured with the following:
      | body             | matching rules          |
      | file: basic.json | include-matcher-v3.json |
    And a request is received with the following:
      | body                               |
      | JSON: { "one": "cat", "two": "b" } |
    When the request is compared to the expected one
    Then the comparison should be OK

  Scenario: Supports an include matcher (negative case)
    Given an expected request configured with the following:
      | body             | matching rules          |
      | file: basic.json | include-matcher-v3.json |
    And a request is received with the following:
      | body                               |
      | JSON: { "one": "dog", "two": "b" } |
    When the request is compared to the expected one
    Then the comparison should NOT be OK
    And the mismatches will contain a mismatch with error "$.one" -> "Expected 'dog' to include 'a'"

  Scenario: Supports a minmax type matcher (positive case)
    Given an expected request configured with the following:
      | body               | matching rules              |
      | file: 3-level.json | minmax-type-matcher-v3.json |
    And a request is received with the following:
      | body                                                                                                        |
      | JSON: { "one": { "a": { "ids": [100], "status": "OK" }  }, "two": [ { "ids": [1,2,3], "status": "BAD" } ] } |
    When the request is compared to the expected one
    Then the comparison should be OK

  Scenario: Supports a minmax type matcher (negative case)
    Given an expected request configured with the following:
      | body               | matching rules              |
      | file: 3-level.json | minmax-type-matcher-v3.json |
    And a request is received with the following:
      | body                                                                                                         |
      | JSON: { "one": { "a": { "ids": [], "status": "OK" }  }, "two": [ { "ids": [1,2,3,4,5], "status": "BAD" } ] } |
    When the request is compared to the expected one
    Then the comparison should NOT be OK
    And the mismatches will contain a mismatch with error "$.one.a.ids" -> "Expected [] (size 0) to have minimum size of 1"
    And the mismatches will contain a mismatch with error "$.two.0.ids" -> "Expected [1, 2, 3, 4, 5] (size 5) to have maximum size of 4"

  Scenario: Supports a number type matcher (positive case)
    Given an expected request configured with the following:
      | body             | matching rules              |
      | file: basic.json | number-type-matcher-v3.json |
    And the following requests are received:
      | body                                  | desc                            |
      | JSON: { "one": 100, "two": "b" }      | Integer number                  |
      | JSON: { "one": 100.01, "two": "b" }   | floating point number           |
    When the requests are compared to the expected one
    Then the comparison should be OK

  Scenario: Supports a number type matcher (negative case)
    Given an expected request configured with the following:
      | body             | matching rules              |
      | file: basic.json | number-type-matcher-v3.json |
    And the following requests are received:
      | body                                  | desc    |
      | JSON: { "one": true, "two": "b" }     | Boolean |
      | JSON: { "one": "100X01", "two": "b" } | String  |
    When the requests are compared to the expected one
    Then the comparison should NOT be OK
    And the mismatches will contain a mismatch with error "$.one" -> "Expected true (True) to be a number"
    And the mismatches will contain a mismatch with error "$.one" -> "Expected '100X01' (String) to be a number"

  Scenario: Supports an integer type matcher, no digits after the decimal point (positive case)
    Given an expected request configured with the following:
      | body             | matching rules               |
      | file: basic.json | integer-type-matcher-v3.json |
    And the following requests are received:
      | body                                  | desc                                |
      | JSON: { "one": 100, "two": "b" }      | Integer number                      |
      | JSON: { "one": "100", "two": "b" }    | String representation of an integer |
    When the requests are compared to the expected one
    Then the comparison should be OK

  Scenario: Supports a integer type matcher, no digits after the decimal point (negative case)
    Given an expected request configured with the following:
      | body             | matching rules               |
      | file: basic.json | integer-type-matcher-v3.json |
    And the following requests are received:
      | body                                  | desc                                      |
      | JSON: { "one": [], "two": "b" }       | Array                                     |
      | JSON: { "one": 100.1, "two": "b" }    | Floating point number                     |
      | JSON: { "one": "100X01", "two": "b" } | Not a string representation of an integer |
    When the requests are compared to the expected one
    Then the comparison should NOT be OK
    And the mismatches will contain a mismatch with error "$.one" -> "Expected [] (Array) to be an integer"
    And the mismatches will contain a mismatch with error "$.one" -> "Expected 100.1 (Decimal) to be an integer"
    And the mismatches will contain a mismatch with error "$.one" -> "Expected '100X01' (String) to be an integer"

  Scenario: Supports an decimal type matcher, must have significant digits after the decimal point (positive case)
    Given an expected request configured with the following:
      | body             | matching rules               |
      | file: basic.json | decimal-type-matcher-v3.json |
    And the following requests are received:
      | body                                    | desc                                             |
      | JSON: { "one": 100.1234, "two": "b" }   | Floating point number                            |
      | JSON: { "one": "100.1234", "two": "b" } | String representation of a floating point number |
    When the requests are compared to the expected one
    Then the comparison should be OK

  Scenario: Supports a decimal type matcher, must have significant digits after the decimal point (negative case)
    Given an expected request configured with the following:
      | body             | matching rules               |
      | file: basic.json | decimal-type-matcher-v3.json |
    And the following requests are received:
      | body                                  | desc                                             |
      | JSON: { "one": null, "two": "b" }     | Null                                             |
      | JSON: { "one": 100, "two": "b" }      | Integer number                                   |
      | JSON: { "one": "100X01", "two": "b" } | Not a string representation of an decimal number |
    When the requests are compared to the expected one
    Then the comparison should NOT be OK
    And the mismatches will contain a mismatch with error "$.one" -> "Expected null (Null) to be a decimal number"
    And the mismatches will contain a mismatch with error "$.one" -> "Expected 100 (Integer) to be a decimal number"
    And the mismatches will contain a mismatch with error "$.one" -> "Expected '100X01' (String) to be a decimal number"

  Scenario: Supports a null matcher (positive case)
    Given an expected request configured with the following:
      | body             | matching rules       |
      | file: basic.json | null-matcher-v3.json |
    And a request is received with the following:
      | body                              |
      | JSON: { "one": null, "two": "b" } |
    When the request is compared to the expected one
    Then the comparison should be OK

  Scenario: Supports an null matcher (negative case)
    Given an expected request configured with the following:
      | body             | matching rules          |
      | file: basic.json | null-matcher-v3.json |
    And a request is received with the following:
      | body                            |
      | JSON: { "one": "", "two": "b" } |
    When the request is compared to the expected one
    Then the comparison should NOT be OK
    And the mismatches will contain a mismatch with error "$.one" -> "Expected '' to be null"

  Scenario: Supports a Date and Time matcher (positive case)
    Given an expected request configured with the following:
      | body             | matching rules       |
      | file: basic.json | date-matcher-v3.json |
    And a request is received with the following:
      | body                                      |
      | JSON: { "one": "2023-07-19", "two": "b" } |
    When the request is compared to the expected one
    Then the comparison should be OK

  Scenario: Supports a Date and Time matcher (negative case)
    Given an expected request configured with the following:
      | body             | matching rules       |
      | file: basic.json | date-matcher-v3.json |
    And a request is received with the following:
      | body                                    |
      | JSON: { "one": "23/07/19", "two": "b" } |
    When the request is compared to the expected one
    Then the comparison should NOT be OK
    And the mismatches will contain a mismatch with error "$.one" -> "Expected '23/07/19' to match a date pattern of 'yyyy-MM-dd'"
