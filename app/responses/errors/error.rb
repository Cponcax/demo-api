module Errors
  class Error
    attr_reader :error, :code, :details
    
    def initialize(error = nil, code = nil, details = nil)
      @error = error
      @code = code
      @details = details
    end

    def error_message
      error.to_s
    end

    def success?
      false
    end
  end
end