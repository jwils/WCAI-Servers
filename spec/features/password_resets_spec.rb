require 'spec_helper'

describe "PasswordResets" do
  it "emails user when requesting password reset" do
    user = create(:user)
    visit new_user_session_path
    click_link "password"
    fill_in "Email", :with => user.email
    click_button "reset password"
    page.should have_content("You will receive an email with instructions")
    last_email.to.should include(user.email)
  end

  it "does not email invalid user when requesting password reset" do
    visit new_user_session_path
    click_link "password"
    fill_in "Email", :with => "madeupuser@example.com"
    click_button "reset password"
    #Is this what we want?!!!
    page.should have_content("not found")
    last_email.should be_nil
  end
end
