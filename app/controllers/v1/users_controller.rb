class V1::UsersController < V1::BaseController
  before_action -> { doorkeeper_authorize! :write }, except: :create
  before_action :set_user, only: [:show, :update, :destroy, :update_password]

  include TokensDoc

  # GET /users
  # GET /users.json
  def index
    @users = User.all

    render json: @users
  end

  api :GET, '/users/me'
  def me
    render json: current_resource_owner
  end

  api :POST, "/users", "Create a user"
  param_group :error, V1::BaseController
  param :user, Hash, :desc => "Contains user information.", :required => true do
    param :username, String, :desc => "Username", :required => false
    param :first_name, String, :desc => "First name", :required => true
    param :last_name, String, :desc => "Last name", :required => true
    param :email, String, :desc => "Email", :required => true
    param :password, String, :desc => "Password (minimum 8 characters)", :required => true
  end
  formats ['json']
  example '
  {
    {
      "user":{
      "id": 5,
      "username": "carol",
      "first_name": "Carol",
      "last_name": "X",
      "email": "gponcax@gmail.com",
      "gender": "female",
      "birth_date": null,
      "bio": null,
      "access_tokens":[
          {
          "access_token": "a1469ea0f52fa4c55a0a9236043d55725ffa7ca684c061afc0ea974666ca11d5",
          "token_type": "bearer",
          "expires_in": 7200,
          "refresh_token": "2d848eae89b13c6142db3833819098bb22151e04a5fcb267060aa04e26c81271",
          "scope": "write",
          "created_at": 1460609090
          }
        ]
      }
    }
  }'
  def create
    @user = User.new(user_params)

    if @user.save && @user.create_access_token
      render json: @user, status: :created
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  api :PUT, "/users/me", "Update a user"
  param_group :error, V1::BaseController
  param :user, Hash, :desc => "Contains user information.", :required => true do
    param :username, String, :desc => "Username"
    param :first_name, String, :desc => "First name"
    param :last_name, String, :desc => "Last name"
    param :email, String, :desc => "Email"
  end
  formats ['json']
  example '
  {
    "user": {
      "username":"carol",
      "first_name":"Carol",
      "last_name":"X",
      "email":"carol@gmail.com"
    }
  }'
  def update
    if @user.update(user_params)
      render json: @user, status: :ok
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  api :DELETE, "/users/me", "Destroy a user"
  param_group :error, V1::BaseController
  formats ['json']
  def destroy
    @user.destroy

    head :no_content
  end

  api :PUT, "/users/update_password", "Update user password"
  param_group :error, V1::BaseController
  param :user, Hash, :desc => "Contains user information.", :required => true do
    param :current_password, String, :desc => "Current password"
    param :password, String, :desc => "New password"
  end
  formats ['json']
  example '
  {
    "user": {
      "current_password": "current_password",
      "password":"new_password"
    }
  }'
  def update_password
    if @user.update_with_password(password_params)
      render json: @user, status: :ok
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end



  private

    def set_user
      @user = current_resource_owner
    end

    def user_params
      params.require(:user).permit(:username, :first_name, :last_name, :email, :password, :gender, :birth_date, :bio)
    end

    def password_params
      params.require(:user).permit(:current_password, :password)
    end
end
