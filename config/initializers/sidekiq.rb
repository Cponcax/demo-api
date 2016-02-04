require 'sidekiq'

Sidekiq.configure_server do |config|
  config.redis = { 
     :url => 'redis://127.0.0.1:6379/2', 
     :namespace => 'esmitv_live_api' 
  }
end

Sidekiq.configure_client do |config|
  config.redis = { 
     :url => 'redis://127.0.0.1:6379/2', 
     :namespace => 'esmitv_live_api' 
  }
end