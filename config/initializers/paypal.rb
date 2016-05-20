#PayPal::SDK.load("config/paypal.yml", Rails.env)
PayPal::SDK.logger = Rails.logger

PayPal::SDK.configure(
  client_id: ENV["client_id"],
  client_secret: ENV["client_secret"],
  username: ENV["username"],
  password: ENV["password"],
  signature: ENV["signature"],
  app_id: ENV["app_id"],
  mode: ENV["mode"],
  http_timeout: 30 
)
