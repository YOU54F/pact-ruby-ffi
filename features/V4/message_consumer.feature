@consumer @message
Feature: Message consumer
  Supports V4 async message consumer interactions

  Scenario: Sets the type for the interaction
    Given a message interaction is being defined for a consumer test
    When the Pact file for the test is generated
    Then the first interaction in the Pact file will have a type of "Asynchronous/Messages"

  Scenario: Supports specifying a key for the interaction
    Given a message interaction is being defined for a consumer test
    And a key of "123ABC" is specified for the message interaction
    When the Pact file for the test is generated
    Then the first interaction in the Pact file will have "key" = '"123ABC"'

  Scenario: Supports specifying the interaction is pending
    Given a message interaction is being defined for a consumer test
    And the message interaction is marked as pending
    When the Pact file for the test is generated
    Then the first interaction in the Pact file will have "pending" = 'true'

  Scenario: Supports adding comments
    Given a message interaction is being defined for a consumer test
    And a comment "this is a comment" is added to the message interaction
    When the Pact file for the test is generated
    Then the first interaction in the Pact file will have "comments" = '{"text":["this is a comment"]}'
