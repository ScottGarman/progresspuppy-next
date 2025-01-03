class Task < ApplicationRecord
  belongs_to :task_category
  belongs_to :user

  # Validation
  STATUS_TYPES = %w[INCOMPLETE COMPLETED].freeze

  validates_presence_of :user_id

  validates :summary, presence: true,
                      length: { maximum: 150 }

  validates :priority, presence: true,
                       inclusion: { in: 1..3 }

  validates :status, presence: true,
                     inclusion: { in: STATUS_TYPES }

  # Scopes
  scope :incomplete,  -> { where(status: :INCOMPLETE) }
  scope :completed,   -> { where(status: :COMPLETED) }
  scope :no_due_date, -> { where("due_at IS NULL") }
end
