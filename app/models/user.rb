class User < ActiveRecord::Base
  acts_as_paranoid
  
  extend Enumerize

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, #:registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # country
  belongs_to :country

  validates :first_name, :last_name, :email, presence: true
  validates :password, presence: true,  length: { in: 6..20 }, on: :create

  validates :bio, length: { maximum: 255 }

  validates :email, format: { with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i, error: :bad_format }, 
                    uniqueness: { case_sensitive: false }

  enumerize :gender, :in => [:male, :female], default: :female, scope: :having_gender

  
  before_create :generate_code

  before_save { self.email = email.downcase }
  
  private

    def generate_code
      begin 
        self.code = 'us' + SecureRandom.hex(3)
      end while !User.where(code: self.code).empty?
    end
end