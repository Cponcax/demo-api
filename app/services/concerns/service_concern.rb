#
# == ServiceConcern
#
# An ActiveSupport::Concern utilized for services.
#
module ServiceConcern
  extend ActiveSupport::Concern

   module ClassMethods
    #
    # Should return a Hash, with the key :status.
    #
    # This class method just creates a new instance of the class, and call its
    # method call.
    #
    def call(current_user, *args)
      if respond_to?(:call)
        new(current_user).call(*args)
      else
        raise InvalidServiceError
      end
    end
   end

  # 
  # == InvalidServiceError
  # 
  # The service don't have an call method.
  #
  class InvalidServiceError < StandardError; end
end