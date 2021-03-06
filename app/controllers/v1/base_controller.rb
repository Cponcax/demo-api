class V1::BaseController < ApplicationController

  skip_before_filter :verify_authenticity_token, :if => Proc.new { |c| c.request.format == 'application/json' }

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def doorkeeper_unauthorized_render_options(error: nil)
    { json: { error: 'You shall not pass' } }
  end

    private

      #Find the user that owns the access token
      def current_resource_owner
        @current_user ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token && doorkeeper_token.scopes.include?('write')
      end

      def record_not_found
        render json: { error: "Record not Found" }, status: 404
      end

      def_param_group :error do
        error :code => 401, :desc => "Unauthorized", :meta => {:message => "It should contain a header 'Authorization' and a 'Bearer' token."}
        error :code => 404, :desc => "Not Found"
        error :code => 422, :desc => "Unprocessable entity"
      end
end