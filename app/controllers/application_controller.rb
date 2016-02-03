class ApplicationController < ActionController::API
  # This is because the serialization is not loaded by default in rails-api.
  include ActionController::Serialization
end
