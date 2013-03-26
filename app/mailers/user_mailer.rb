class UserMailer < ActionMailer::Base
  default from: "wcai-research@wharton.upenn.edu"

  def added_to_project(user, project)
    @user = user
    @project = project
    mail(:to => "#{user.name} <#{user.email}>", :subject => "You have been added to a research project by #{project.name}")
  end

  def send_email_to_list(current_user, users, subject, text)
    @msg_body = text
    to_users = users.map {|u| "#{u.name} <#{u.email}>"}.join(', ')
    from = current_user.nil? ? "wcai-research@wharton.upenn.edu" : "#{current_user.name} <#{current_user.email}>"
    mail(:from => from,
         :to => to_users, :subject => subject)
  end
end
