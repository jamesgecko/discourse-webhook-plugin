# name: webhook-notifications
# about: Instead of sending email, call a webhook
# authors: @jamesgecko

after_initialize do
  load File.expand_path("../email_helper.rb", __FILE__)
end
