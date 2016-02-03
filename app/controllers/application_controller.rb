require "application_responder"

class ApplicationController < ActionController::API
  self.responder = ApplicationResponder
  respond_to :json

  # This is because the serialization is not loaded by default in rails-api.
  include ActionController::Serialization
end
