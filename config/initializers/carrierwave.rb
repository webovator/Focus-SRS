CarrierWave.configure do |config|
  config.fog_credentials = {
    :provider               => 'AWS',
    :aws_access_key_id      => 'AKIAILKXQWKJZPLUS6MA',
    :aws_secret_access_key  => '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',
    :region                 => 'us-east-1'
  }
  config.fog_directory  = 'focussrs'
  config.fog_host       = 'https://assets.focussrs.com'
  config.fog_public     = true
  config.fog_attributes = {'Cache-Control' => 'max-age=315576000'}
end