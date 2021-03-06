CarrierWave.configure do |config|
  config.fog_credentials = {
    :provider               => 'AWS',       # required
    :aws_access_key_id      => Settings.aws_access_key,      # required
    :aws_secret_access_key  => Settings.aws_secret_key       # required
#    :region                 => 'eu-west-1'  # optional, defaults to 'us-east-1'
  }
  config.fog_directory  = Settings.aws_bucket                    # required
  config.fog_public     = false     
  config.fog_authenticated_url_expiration = 120
  config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}  # optional, defaults to {}
  #config.asset_host     = 'https://assets.example.com'            # optional, defaults to nil
  
end