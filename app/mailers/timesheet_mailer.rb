class TimesheetMailer  < ActionMailer::Base
  def timesheet_reminder(from)
    to_users = User.with_role(:research_assistant).map {|u| "#{u.name} <#{u.email}>"}.join(', ')
    from_user =  "#{from.name} <#{from.email}>"
    @week_ending = Date.parse('Monday') - 1.day
    @users_name = from.name
    mail(:to => to_users, :from => from_user,
         :cc => from_user, :subject => "REMINDER timesheets w/e #{@week_ending}")
  end
end