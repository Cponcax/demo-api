class ApplicationResponder < ActionController::Responder
  # Automatically adds Last-Modified headers to API requests. This allows clients to easily query the server if a resource changed and if the client tries to retrieve 
  # a resource that has not been modified, it returns not_modified status.
  include Responders::HttpCacheResponder

  # Redirects resources to the collection path (index action) instead
  # of the resource path (show action) for POST/PUT/DELETE requests.
  # include Responders::CollectionResponder

    # All other formats follow the procedure below. First we try to render a
    # template, if the template is not available, we verify if the resource
    # responds to :to_format and display it.
    #
    def to_format
      if get? || !has_errors? || response_overridden?
        default_render
      else
        display_errors
      end
    rescue ActionView::MissingTemplate => e
      api_behavior(e)
    end

    private

      # This is the common behavior for formats associated with APIs, such as :xml and :json.
      def api_behavior(error)
        raise error unless resourceful?
        raise MissingRenderer.new(format) unless has_renderer?

        if get?
          display resource
        elsif post?
          display resource, status: :created, location: api_location
        elsif put?
          display resource, status: :ok, location: api_location
      	else
      	  head :no_content
        end
      end

      # Checks whether the resource responds to the current format or not.
	  #
	  def resourceful?
	    resource.respond_to?("to_#{format}")
	  end


	  def display(resource, options = {})
	    super(resource.data, options)
	  end

	  def has_errors?
	    !resource.success?
	  end

	  def json_resource_errors
	    { error: resource.error, message: resource.error_message, code: resource.code, details: resource.details }
	  end

	  def api_location
	    nil
	  end
end
