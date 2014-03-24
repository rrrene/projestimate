#This load the file that contain the rails protected parameters
unless Rails.env.test?
  SETTINGS = YAML.load(IO.read(Rails.root.join("config", "sensitive_settings.yml")))
end

#You need to set the following parameters wih your own values in your "config/sensitive_settings.yml" file that you have to create locally

# SECRET_TOKEN: your_generated_token_value
#
# SMTP_ADDRESS: smtp.sample.com
#
# SMTP_PORT: your_SMTP_Port_Number
#
# SMTP_DOMAIN: your_domain.com
#
# SMTP_USER_NAME: your_SMTP_username
#
# SMTP_PASSWORD: your_SMTP_password
#
