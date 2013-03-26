Feature: Show Users
  As a visitor to the website
  I want to see registered users listed on the homepage
  so I can know if the site has users

    Scenario: Viewing myself
      Given I am logged in as an "Administrator"
      When I look at the list of users
      Then I should see my name

    Scenario: Locking a user
      Given I am logged in as an "Administrator"


