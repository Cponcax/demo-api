class Oauth::TokensController < Doorkeeper::TokensController
  include AbstractController::Callbacks

  after_action :identify_origin, only: [:create]

  private

    def identify_origin
      if response.status.eql? 200 
        current_user = User.find(authorize_response.token.resource_owner_id)
        
        # request.remote_ip
        # example: '147.243.3.83'
        Countries::IdentifyCountry.new(current_user, "147.243.3.83").call()
      end
    end

end