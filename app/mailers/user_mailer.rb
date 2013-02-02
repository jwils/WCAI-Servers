class UserMailer < ActionMailer::Base
  default from: "wcai-research@wharton.upenn.edu"

  def added_to_project(user, project)
    @user = user
    @project = project
    mail(:to => user.email, :subject => "You have been added to a research project by #{project.company.name}")
  end

  def send_email_to_list(current_user, users, project, subject, text)
    @msg_body = text
    mail(:from => current_user.email,  :to => users.map(&:email), :subject => subject)
  end
end