class User < ActiveRecord::Base
  acts_as_paranoid

  extend Enumerize

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,# :async,#:registerable,
         :recoverable, :rememberable, :registerable, :trackable, :validatable

  # country
  belongs_to :country

  # access tokens from doorkeeper

  # the reason why we do not use the access token as the name of the relationship, 
  # is because apparently generates conflict to call it in the relationship
  has_many :tokens, class_name: Doorkeeper::AccessToken, foreign_key: :resource_owner_id

  has_one :token, -> { order 'created_at DESC' }, class_name: Doorkeeper::AccessToken, foreign_key: :resource_owner_id

  # reminders
  has_many :reminders

  #for sdk paypal
  has_many :payment_tokens

  has_many :subscriptions
  
  validates :first_name, :last_name, :email, presence: true

  #validates :email, uniqueness: true
  
  #validates_uniqueness_of :email, :on => :create

  validates :password, presence: true,  length: { in: 6..20 }, on: :create

  validates :bio, length: { maximum: 255 }

  validates :email, format: { with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i },
                 uniqueness: true

  enumerize :gender, :in => [:male, :female], default: :female, scope: :having_gender
  enumerize :status, in: [:active, :inactive, :banned], default: :active, scope: :having_account_status, predicates: true


  before_create :generate_code
  
  after_create :create_access_token


  before_save { self.email = email.downcase }

  def alive_tokens
    tokens.select {|token| !token.revoked? }
  end

  def create_access_token
    puts "::::CREANDO TOKEN::::::::"
    @request ||= Doorkeeper::OAuth::PasswordAccessTokenRequest.new(
         Doorkeeper.configuration,
         nil,
         self,
         { grant_type: "password", scope: "write" }
       )
     @response = @request.authorize
     @token = @response.token

     puts ":::RESPONSE :::" + @response.inspect

     puts ":::TOKEN::" + @token.inspect
  end


  private

    def generate_code
      begin
        self.code = 'us' + SecureRandom.hex(3)
      end while !User.where(code: self.code).empty?
    end
end
