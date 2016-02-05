require "application_responder"

class ApplicationController < ActionController::API
  self.responder = ApplicationResponder
  respond_to :json

  # This is because the serialization is not loaded by default in rails-api.
  include ActionController::Serialization

  include ActionController::RequestForgeryProtection
  include ActionView::Layouts
  include AbstractController::Rendering
  #include ActionController::MimeResponds
  include AbstractController::Translation
  include ActionController::ImplicitRender
  include ActionController::Helpers
end
