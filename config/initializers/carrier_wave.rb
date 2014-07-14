AWS_CONFIG = YAML.load_file(Rails.root.join('config/aws.yml'))

CarrierWave.configure do |config|
  config.fog_credentials = {
    :provider               => 'AWS',
    :aws_access_key_id      => AWS_CONFIG["access_key_id"],
    :aws_secret_access_key  => AWS_CONFIG["secret_access_key"],
    :region                 => 'eu-west-1'
  }

  config.fog_directory  = 'am-books'
end
