class RecordNotFoundError < Errors::Error

  def initialize(details)
    super(:record_not_found, 201, details)
  end

  def error_message
    "Record not found: see details"
  end

end