module Users
	class CreateUser < BaseService

		def call(user_params = {})
			user = User.new(user_params)

			if user.save
		    Success.new(user)
		  else
		    ValidationError.new(user.errors)
		  end
		end

	end
end
