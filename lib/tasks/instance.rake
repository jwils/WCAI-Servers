task :check_instance_uptime => :environment do
  Server.all.each do |server|
  	unless server.stopped?
  		if server.open_connections.length == 0
  			puts 'send email server should be shut down'
  		end

  		server.open_connections.each do |connection|
  			if connection.connection_open + 2.hours > DateTime.now
  				#mail me
  				puts 'send email'
  			end
  		end 
		end
	end

	 FOG_CONNECTION.servers.each do |instance|
  	if Server.find_by_instance_id(instance.id).nil?
  		#unassociated server send
  		puts 'send emai unassociated instance'
  	end
  end
end

