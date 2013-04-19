class InstanceReportMailer < ActionMailer::Base
  default from: "wcai-research@wharton.upenn.edu"

  def uptime_report(users, instance)
    to_users = users.map { |u| "#{u.name} <#{u.email}>" }.join(', ')
    @instance = instance
    mail(:to => to_users, :subject => "Server on for more than three hours")
  end
end