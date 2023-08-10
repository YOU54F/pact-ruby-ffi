Feature: V3 era Generators

  Scenario: Supports a random integer generator
    Given a request configured with the following generators:
      | body             | generators               |
      | file: basic.json | randomint-generator.json |
    When the request is prepared for use
    Then the body value for "$.one" will have been replaced with a "integer"

  Scenario: Supports a random decimal generator
    Given a request configured with the following generators:
      | body             | generators               |
      | file: basic.json | randomdec-generator.json |
    When the request is prepared for use
    Then the body value for "$.one" will have been replaced with a "decimal number"

  Scenario: Supports a random hexadecimal generator
    Given a request configured with the following generators:
      | body             | generators               |
      | file: basic.json | randomhex-generator.json |
    When the request is prepared for use
    Then the body value for "$.one" will have been replaced with a "hexadecimal number"

  Scenario: Supports a random string generator
    Given a request configured with the following generators:
      | body             | generators               |
      | file: basic.json | randomstr-generator.json |
    When the request is prepared for use
    Then the body value for "$.one" will have been replaced with a "random string"

  Scenario: Supports a regex generator
    Given a request configured with the following generators:
      | body             | generators                 |
      | file: basic.json | randomregex-generator.json |
    When the request is prepared for use
    Then the body value for "$.one" will have been replaced with a "string from the regex"

  Scenario: Supports a date generator
    Given a request configured with the following generators:
      | body             | generators          |
      | file: basic.json | date-generator.json |
    When the request is prepared for use
    Then the body value for "$.one" will have been replaced with a "date"

  Scenario: Supports a time generator
    Given a request configured with the following generators:
      | body             | generators          |
      | file: basic.json | time-generator.json |
    When the request is prepared for use
    Then the body value for "$.one" will have been replaced with a "time"

  Scenario: Supports a date-time generator
    Given a request configured with the following generators:
      | body             | generators              |
      | file: basic.json | datetime-generator.json |
    When the request is prepared for use
    Then the body value for "$.one" will have been replaced with a "date-time"

  Scenario: Supports a UUID generator
    Given a request configured with the following generators:
      | body             | generators          |
      | file: basic.json | uuid-generator.json |
    When the request is prepared for use
    Then the body value for "$.one" will have been replaced with a "UUID"

  Scenario: Supports a boolean generator
    Given a request configured with the following generators:
      | body             | generators             |
      | file: basic.json | boolean-generator.json |
    When the request is prepared for use
    Then the body value for "$.one" will have been replaced with a "boolean"
