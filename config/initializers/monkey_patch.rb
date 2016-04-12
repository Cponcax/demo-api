Rails.application.config.to_prepare do
  Doorkeeper::OAuth::PasswordAccessTokenRequest.class_eval do
    validate :alive_tokens , error: :limit_tokens


  def initialize(server, credentials, resource_owner, parameters = {})
    @server          = server
    @resource_owner  = resource_owner
    @credentials     = credentials
    @original_scopes = parameters[:scope]

    if credentials
      @client = Application.by_uid_and_secret credentials.uid,
                                              credentials.secret
    end
  end

    private

      def validate_alive_tokens
        resource_owner.alive_tokens.size < 2
      end
  end
end

Rails.application.config.to_prepare do
  Doorkeeper::Errors.class_eval do

    class DoorkeeperError < StandardError
    end

    class InvalidAuthorizationStrategy < DoorkeeperError
    end

    class InvalidTokenReuse < DoorkeeperError
    end

    class InvalidGrantReuse < DoorkeeperError
    end

    class InvalidTokenStrategy < DoorkeeperError
    end

    class MissingRequestStrategy < DoorkeeperError
    end

    class UnableToGenerateToken < DoorkeeperError
    end

    class TokenGeneratorNotFound < DoorkeeperError
    end

    class InvalidTokenLimit < DoorkeeperError
    end
  end
end

Rails.application.config.to_prepare do
  Doorkeeper::Helpers::Controller.class_eval do
      def get_error_response_from_exception(exception)
        error_name = case exception
                     when Errors::InvalidTokenStrategy
                       :unsupported_grant_type
                     when Errors::InvalidAuthorizationStrategy
                       :unsupported_response_type
                     when Errors::MissingRequestStrategy
                       :invalid_request
                     when Errors::InvalidTokenReuse
                       :invalid_request
                     when Errors::InvalidGrantReuse
                       :invalid_grant
                     when Errors::InvalidTokenLimit
                       :limit_tokens
                     when Errors::DoorkeeperError
                       exception.message
                     end

        OAuth::ErrorResponse.new name: error_name, state: params[:state]
      end
  end
end
