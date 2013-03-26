Feature: Create Users
  In order to get access to protected sections of the site
  Users must be created by an admin


    Background:
      Given I am logged in as an "Administrator"
      And a clear email queue

    Scenario:
      When I invite 3 new administrators
      Then I see that the emails were sent
      And They should each receive an email


