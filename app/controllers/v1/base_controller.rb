class V1::BaseController < ApplicationController

  skip_before_filter :verify_authenticity_token, :if => Proc.new { |c| c.request.format == 'application/json' }

  def doorkeeper_unauthorized_render_options(error: nil)
    { json: { error: 'You shall not pass' } }
  end

    private

      #Find the user that owns the access token
      def current_resource_owner
        @current_user ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token && doorkeeper_token.scopes.include?('write')
      end
end