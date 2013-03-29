task :check_instance_up_time => :environment do
  Server.all.each do |server|
  	unless server.stopped?
  		if server.open_connections.length == 0
        UserMailer.send_email_to_list(nil, User.with_role(:admin),"Server on without any connections",
                           "There appears to be a server turned on without any open connections. Please shut it down manually.").deliver
  		end
  		server.open_connections.each do |connection|
  			if connection.connection_open + 3.hours < DateTime.now
          UserMailer.instance_uptime_report(User.with_role(:admin), server).deliver
  			end
  		end 
		end
	end

	 FOG_CONNECTION.servers.each do |instance|
  	if Server.find_by_instance_id(instance.id).nil?
  		#unassociated server send
  		puts 'send email unassociated instance'
  	end
  end
end

task :test_instance => :environment do
  s = Server.new
  s.create_aws_instance
end

