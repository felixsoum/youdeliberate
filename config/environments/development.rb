App60::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # set up smtp server for sending emails.
  config.action_mailer.default_url_options = {:host => 'localhost:3000'} 
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.perform_deliveries = true
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.default :charset => "utf-8"
  config.action_mailer.smtp_settings = {
    address: "smtp.mandrillapp.com",
    port: 587,
    domain: "example.com",
    authentication: "plain",
    enable_starttls_auto: true,
    user_name: "ldohxc@hotmail.com",
    password: "H28-OD-cVMTJ_bTplKi8-Q"
  }


  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true
  
  # replace this with your development tracker code
  GA.tracker = "UA-48522301-2"
  
end
