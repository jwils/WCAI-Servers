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

  def instance_uptime_report(users, instance)
    to_users = users.map {|u| "#{u.name} <#{u.email}>"}.join(', ')
    @instance = instance
    mail(:to => to_users, :subject => "Server on for more than three hours")
  end

  def timesheet_reminder
    to_users = User.with_role(:research_assistant).map {|u| "#{u.name} <#{u.email}>"}.join(', ')
    @week_ending = Date.parse('Monday') - 1.day
    @users_name = current_user.name
    mail(:to => to_users, :from => "#{current_user.name} <#{current_user.email}>",
         :subject => "REMINDER timesheets w/e #{@week_ending}")
  end
end
