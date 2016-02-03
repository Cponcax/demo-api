class ValidationError < Errors::Error

  def initialize(details)
    super(:validation_failed, 101, details)
  end

  def error_message
    "Validation failed: see details"
  end

end