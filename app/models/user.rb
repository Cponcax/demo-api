class User < ActiveRecord::Base
  acts_as_paranoid

  extend Enumerize

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  # devise :database_authenticatable,# :async,#:registerable,
  #        :recoverable, :rememberable, :registerable, :trackable, :validatable

  devise :database_authenticatable,# :async,#:registerable,
        :recoverable, :rememberable, :trackable #, :validatable

  # customers
  has_one :customer, dependent: :destroy
  
  # subscriptions
  has_many :subscriptions, through: :customer

  # access tokens from doorkeeper

  # the reason why we do not use the access token as the name of the relationship,
  # is because apparently generates conflict to call it in the relationship
  has_many :tokens, class_name: Doorkeeper::AccessToken, foreign_key: :resource_owner_id

  has_one :token, -> { order 'created_at DESC' }, class_name: Doorkeeper::AccessToken, foreign_key: :resource_owner_id

  # reminders
  has_many :reminders

  # receipts
  has_many :itunes_receipts, dependent: :destroy

  validates :first_name, :last_name, :email, presence: true

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
    tokens.order(created_at: :asc).select {|token| !token.revoked? }
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

  def validate_itunes_receipt
    receipt = self.itunes_receipts.first.receipt
    if receipt
      uri = URI('https://sandbox.itunes.apple.com/verifyReceipt')
      req = Net::HTTP::Post.new(uri, initheader = { 'Content-Type' => 'application/json' })
      req.body = { "receipt-data" => self.itunes_receipts.last.receipt, "password" => "0d57caf2188a43b395cb7b54909d49ed" }.to_json
      res = Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') {|http| http.request req}
      puts res.body
    else
      puts 'Error'
    end
  end

  def get_current_subscription
    subscriptions.find_by(ended_at: nil)
  end

  private

    def generate_code
      begin
        self.code = 'us' + SecureRandom.hex(3)
      end while !User.where(code: self.code).empty?
    end
end
