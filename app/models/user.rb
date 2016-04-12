class User < ActiveRecord::Base
  acts_as_paranoid

  extend Enumerize

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,# :async,#:registerable,
         :recoverable, :rememberable, :trackable #, :validatable

  # country
  belongs_to :country

  # access tokens from doorkeeper
  has_many :access_tokens, class_name: "Doorkeeper::AccessToken", foreign_key: "resource_owner_id"

  # reminders
  has_many :reminders
  #for sdk paypal
  has_many :payment_tokens
  
  validates :first_name, :last_name, :email, presence: true
  validates :password, presence: true,  length: { in: 6..20 }, on: :create

  validates :bio, length: { maximum: 255 }

  validates :email, format: { with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i, error: :bad_format },
                 uniqueness: { case_sensitive: false }

  enumerize :gender, :in => [:male, :female], default: :female, scope: :having_gender
  enumerize :status, in: [:active, :inactive, :banned], default: :active, scope: :having_account_status, predicates: true


  before_create :generate_code

  before_save { self.email = email.downcase }

  def alive_tokens
    access_tokens.select {|token| !token.revoked? }
  end

  def create_access_token
    @request ||= Doorkeeper::OAuth::PasswordAccessTokenRequest.new(
         Doorkeeper.configuration,
         nil,
         self,
         { grant_type: "password", scope: "write" }
       )
     @response = @request.authorize
     @token = @response.token
  end


  private

    def generate_code
      begin
        self.code = 'us' + SecureRandom.hex(3)
      end while !User.where(code: self.code).empty?
    end
end
