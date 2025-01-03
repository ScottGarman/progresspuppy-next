class User < ApplicationRecord
  has_secure_password
  has_one  :setting, dependent: :destroy
  has_many :quotes, dependent: :destroy
  has_many :task_categories, dependent: :destroy
  has_many :tasks, dependent: :destroy
  has_many :sessions, dependent: :destroy

  # Validation
  EMAIL_REGEX = /\A[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,4}\Z/i.freeze
  normalizes :email_address, with: ->(e) { e.strip.downcase }

  validates :first_name, presence: true,
                         length: { maximum: 50 }

  validates :last_name, presence: true,
                         length: { maximum: 50 }

  validates :email_address, presence: true,
                            length: { within: 3..255 },
                            format: EMAIL_REGEX,
                            uniqueness: { case_sensitive: false }

  validates :password, presence: true, length: { minimum: 14 }, allow_nil: true

  after_create :create_user_settings, :create_default_task_category

  private

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
