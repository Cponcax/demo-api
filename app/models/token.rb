class Token < ActiveRecord::Base
  belongs_to  :customer

  def expired?
    expires_in && Time.now.utc > expired_time
  end

  private

    def expired_time
      created_at + expires_in.seconds
    end
end
