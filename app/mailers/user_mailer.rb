class UserMailer < ActionMailer::Base
  default from: "wcai-research@wharton.upenn.edu"

  #Email existing user that they were added to a new project.
  #Currently this email is sent when they are added through batch add
  #but not when toggled from /show
  def added_to_project(user, project)
    @user = user
    @project = project
    mail(:to => "#{user.name} <#{user.email}>", :subject => "You have been added to a research project by #{project.name}")
  end

  #Generic send email to a list of users. All current implementations have been converted
  #to specialized functions. This remains since in the future we may want to let users send
  # emails to everyone in a project.

  def send_email_to_list(current_user, users, subject, text)
    @msg_body = text
    to_users = users.map { |u| "#{u.name} <#{u.email}>" }.join(', ')
    from = current_user.nil? ? "wcai-research@wharton.upenn.edu" : "#{current_user.name} <#{current_user.email}>"
    mail(:from => from,
         :to => to_users, :subject => subject)
  end
end
