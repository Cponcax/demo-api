require 'concerns/service_concern'
require 'errors/validation_error'
require 'errors/record_not_found_error'

#
# == BaseService
#
# @abstract
#
# A service is used to remove logic from models.
#
# Abstract base class for app services.
#
# Normally the services has the following characteristics:
#   - Involves at least three models directly.
#   - Does not belong to the core logic for the model.
#   - Involves complex operations.
#   - Involves a third party service (ex. Stripe, Mailchimp).
#   - There's more than one way to do it ( http://www.wikiwand.com/en/Strategy_pattern ).
#
# A service call method should return a Hash.
# The returned hash should had an :status key, and its value must be :error or :success.
#
class BaseService
  include ServiceConcern

  attr_reader :current_user, :params

  #
  # @param [User] current_user
  #
  def initialize(current_user, params = {})
    @current_user = current_user
    @params = params.dup
  end

  #
  # Override this method to implement the functionality
  # of the service.
  #
  # @return [Result]
  def call(*args)
    raise NotImplementedError
  end

  def not_found record
    unless record
      RecordNotFoundError.new({ id: ['Not found']})
    end
  end

end