AWS_CONFIG = YAML.load_file(Rails.root.join('config/secrets.yml'))[Rails.env]

CarrierWave.configure do |config|
  config.fog_credentials = {
    :provider               => 'AWS',
    :aws_access_key_id      => AWS_CONFIG["aws_access_key_id"],
    :aws_secret_access_key  => AWS_CONFIG["aws_secret_access_key"],
    :region                 => 'eu-west-1'
  }

  config.fog_directory  = 'am-books'
end
