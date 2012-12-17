FOG_CONNECTION = Fog::Compute.new({
    :aws_access_key_id => Settings.aws_access_key,
    :aws_secret_access_key => Settings.aws_secret_key,
    :provider => "AWS"
  })


FOG_STORAGE = Fog::Storage.new({
    :aws_access_key_id => Settings.aws_access_key,
    :aws_secret_access_key => Settings.aws_secret_key,
    :provider => "AWS"
  })