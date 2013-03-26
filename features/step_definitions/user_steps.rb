### UTILITY METHODS ###

def create_visitor
  @visitor ||= { :name => "Testy McUserton", :email => "example@example.com",
    :password => "changeme", :password_confirmation => "changeme" }
end

def find_user
  @user ||= User.where(:email => @visitor[:email]).first
end

def create_user(role = "Administrator")
  create_visitor
  delete_user
  symbol_role = role.parameterize.underscore.to_sym
  @user = FactoryGirl.create(:user, symbol_role, @visitor)
end

def create_email_list(number_of_emails)
  @email_list = []
  number_of_emails.times { |x| @email_list << "test_user#{x}@example.com"}
end
def delete_user
  @user ||= User.where(:email => @visitor[:email]).first
  @user.destroy unless @user.nil?
end

def sign_in
  visit '/users/sign_in'
  fill_in "user_email", :with => @visitor[:email]
  fill_in "user_password", :with => @visitor[:password]
  click_button "Sign in"
end

### GIVEN ###
Given /^I am not logged in$/ do
  visit '/users/sign_out'
end

Given /^I am an? "(.+)"/ do |role|
  create_user(role)
end

Given /^I am logged in as an? "(.+)"/ do |role|
  create_user(role)
  sign_in
end

Given /^I am logged in$/ do
  create_user
  sign_in
end

Given /^I exist as a user$/ do
  create_user
end

Given /^I do not exist as a user$/ do
  create_visitor
  delete_user
end

### WHEN ###
When /^I sign in with valid credentials$/ do
  create_visitor
  sign_in
end

When /^I sign out$/ do
  visit '/users/sign_out'
end

When /^I return to the site$/ do
  visit '/'
end

When /^I sign in with a wrong email$/ do
  @visitor = @visitor.merge(:email => "wrong@example.com")
  sign_in
end

When /^I sign in with a wrong password$/ do
  @visitor = @visitor.merge(:password => "wrongpass")
  sign_in
end

When /^I edit my name$/ do
  click_link "Edit your account"
  fill_in "user_name", :with => "newname"
  fill_in "user_current_password", :with => @visitor[:password]
  click_button "Update"
end

When /^I change my password$/ do
  click_link "Edit your account"
  fill_in "user_password", :with => "newpassword"
  fill_in "user_password_confirmation", :with => "newpassword"
  fill_in "user_current_password", :with => @visitor[:password]
  click_button "Update"
end

When /^I look at the list of users$/ do
  visit '/users/'
end

When /^I invite (\d+) new administrators$/ do |count|
  visit '/users/new_batch'
  select "admin", from: "invitations_role"
  create_email_list(count.to_i)
  fill_in "invitations_user_emails", :with => @email_list.join("\n")
  click_button "Send"
end

### THEN ###
Then /^I should be signed in$/ do
  page.should have_content "Logout"
  page.should_not have_content "Sign up"
  page.should_not have_content "Sign in"
  page.should_not have_content "Login"
end

Then /^I should be signed out$/ do
  page.should have_content "Sign in"
  page.should have_content "Login" #Not needed but will leave for now.
  page.should_not have_content "Sign up" #Users should not be able to register themseleves
  page.should_not have_content "Logout"
end

Then /^I see that the emails were sent$/ do
  page.should have_content "Email invitations sent"
end

Then /^I see a successful sign in message$/ do
  page.should have_content "Signed in successfully."
end

Then /^I should see an invalid email message$/ do
  page.should have_content "Email is invalid"
end

Then /^I should see a missing password message$/ do
  page.should have_content "Password can't be blank"
end

Then /^I should see a signed out message$/ do
  page.should have_content "Signed out successfully."
end

Then /^I see an invalid login message$/ do
  page.should have_content "Invalid email or password."
end

Then /^I should see an account edited message$/ do
  page.should have_content "You updated your account successfully."
end

Then /^I should see my name$/ do
  create_user
  page.should have_content @user[:name]
end

Then /^They should each receive an email$/ do
  @email_list.each do |email|
    unread_emails_for(email).size.should >= parse_email_count(1)
  end
end
