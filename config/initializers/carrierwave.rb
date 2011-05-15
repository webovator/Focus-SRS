CarrierWave.configure do |config|
  config.root = Rails.root.join('tmp')
  config.cache_dir = 'carrierwave'

  config.s3_access_key_id = ENV['AKIAILKXQWKJZPLUS6MA']
  config.s3_secret_access_key = ENV['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']
  config.s3_bucket = ENV['focussrs']
end
