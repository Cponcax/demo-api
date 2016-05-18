Rails.application.config.to_prepare do
  Doorkeeper::AccessTokenMixin.class_eval do
    def generate_token
        self.created_at ||= Time.now.utc

        generator = Doorkeeper.configuration.access_token_generator.constantize
        self.token = generator.generate(
          resource_owner_id: resource_owner_id,
          scopes: scopes,
          application: application,
          expires_in: expires_in,
          created_at: created_at
        )

        if token
          # User the resource_owner_id from token to identify the user
          user = User.find(resource_owner_id) rescue nil

          if user && user.alive_tokens.size >= 2
            # Revoke old token from user alive tokens
            user.alive_tokens[0].update(revoked_at: Time.now.utc)
          end
        end
        
    rescue NoMethodError
      raise Errors::UnableToGenerateToken, "#{generator} does not respond to `.generate`."
    rescue NameError
      raise Errors::TokenGeneratorNotFound, "#{generator} not found"
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

Rails.application.config.to_prepare do
  Doorkeeper::OAuth::TokenResponse.class_eval do
      def body
        # User the resource_owner_id from token to identify the user
        user = User.find(token.resource_owner_id) rescue nil

        {
          'access_token'  => token.token,
          'testtt'  => "sdadasdas",
          'token_type'    => token.token_type,
          'expires_in'    => token.expires_in_seconds,
          'refresh_token' => token.refresh_token,
          'scope'         => token.scopes_string,
          'created_at'    => token.created_at.to_i,
          'user'          => (Hash["first_name", user.first_name, "last_name", user.last_name, "email", user.email] rescue {})
        }.reject { |_, value| value.blank? }
      end

  end
end