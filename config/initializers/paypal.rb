#PayPal::SDK.load("config/paypal.yml", Rails.env)
PayPal::SDK.logger = Rails.logger

PayPal::SDK.configure(
  client_id: ENV["client_id"],
  client_secret: ENV["client_secret"],
  mode: ENV["mode"]
 
)
