class Payment < ApplicationRecord
  belongs_to :subscription

  validates :amount, presence: true
  validates :amount, numericality: { greater_than: 0 }
  validates :status, inclusion: { in: %w[completed pending failed] }
end