task :create_instance => :environment do
  server = FOG_CONNECTION.servers.bootstrap(:image_id => "ami-a29943cb",
                                    #:type =>
                                     :private_key_path =>'~/.ssh/fog',
                                     :public_key_path => '~/.ssh/fog.pub',
                                    :username => 'ubuntu')
  server.wait_for { ready? }
  puts server.ssh('ls')
  server.stop
end
