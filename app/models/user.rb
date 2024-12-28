class User < ApplicationRecord
  has_secure_password
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
end
