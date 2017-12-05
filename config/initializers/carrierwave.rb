if Rails.env.production?
  CarrierWave.configure do |config|
    config.fog_credentials = {
      # Configuration for Amazon S3
      :provider              => 'AWS',
      :aws_access_key_id     => ENV.fetch['AWS_ACCESS_KEY'],
      :aws_secret_access_key => ENV.fetch['AWS_SECRET_KEY']
    }
    config.fog_directory     =  ENV.fetch['AWS_BUCKET']
  end
else
  CarrierWave.configure do |config|
  config.storage :file
end
end
