# SMTP Mail configuration
ActionMailer::Base.smtp_settings = {
    :address => SETTINGS['SMTP_ADDRESS'],
    :port => SETTINGS['SMTP_PORT'],
    :domain => SETTINGS['SMTP_DOMAIN'],
    :user_name => SETTINGS['SMTP_USER_NAME'],
    :password => SETTINGS['SMTP_PASSWORD'],
    :authentication => SETTINGS['SMTP_AUTHENTICATION'],
    :enable_starttls_auto => true
}

ProjestimateMaquette::Application.config.action_mailer.default_url_options = { :host => SETTINGS['HOST_URL'] }
