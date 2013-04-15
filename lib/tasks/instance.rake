task :check_instance_up_time => :environment do
  Server.all.each do |server|
  	server.check_uptime
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

