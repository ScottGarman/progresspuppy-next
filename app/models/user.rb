class User < ApplicationRecord
  has_one :setting, dependent: :destroy
  has_many :task_categories, dependent: :destroy
  has_many :tasks, dependent: :destroy
  has_many :quotes, dependent: :destroy

  has_secure_password

  # Validation
  EMAIL_REGEX = /\A[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,4}\Z/i.freeze

  validates :first_name, presence: true,
                         length: { maximum: 50 }

  validates :last_name, presence: true,
                        length: { maximum: 50 }

  validates :email, presence: true,
                    length: { within: 3..255 },
                    format: EMAIL_REGEX,
                    uniqueness: { case_sensitive: false },
                    confirmation: true

  validates :password, presence: true, length: { minimum: 12 }, allow_nil: true

  # Make it easier to prevent email duplicates by downcasing them by default:
  before_save   :downcase_email
  after_create  :create_user_settings, :create_default_task_category

  # Returns the hash digest of the given string
  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # Returns a random token
  def self.new_token
    SecureRandom.urlsafe_base64
  end

  # Returns true if the given token matches the digest
  def authenticated?(attribute, token)
    # self is implied with send here:
    digest = send("#{attribute}_digest")
    return false if digest.nil?

    BCrypt::Password.new(digest).is_password?(token)
  end

  private

  # Returns email in all lowercase
  def downcase_email
    email.downcase!
  end

  # Creates and assigns the activation token and digest
  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest(activation_token)
  end

  # Ensure each User has an associated Setting object
  def create_user_settings
    self.setting = Setting.new
  end

  # Ensure each User has an 'Uncategorized' TaskCategory that will be used for
  # tasks where a TaskCategory is not set
  def create_default_task_category
    task_categories << TaskCategory.new(name: "Uncategorized")
  end
end
