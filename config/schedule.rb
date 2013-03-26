# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
every 2.hours do
   rake "check_instance_up_time"
end


every 1.day, :at => '7:00 pm' do
  rake "MyModel.task_to_run_at_four_thirty_in_the_morning"
end