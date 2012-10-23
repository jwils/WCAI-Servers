task :create_instance => :environment do
  compute = Fog::Compute.new({
    :aws_access_key_id => Settings.aws_access_key,
    :aws_secret_access_key => Settings.aws_secret_key,
    :provider => "AWS"
  })
  server = compute.servers.bootstrap(:image_id => "ami-a29943cb",
                                    #:type =>
                                     :private_key_path =>'~/.ssh/fog',
                                     :public_key_path => '~/.ssh/fog.pub',
                                     :username => 'ubuntu')
  server.wait_for { ready? }
  puts server.ssh('ls')
  server.stop
end
