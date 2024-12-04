class Subscription < ApplicationRecord
  belongs_to :customer
  has_many :payments, dependent: :destroy

  validates :amount, presence: true
  validates :outstanding_balance, numericality: { greater_than_or_equal_to: 0 }
  validates :customer_id, presence: true

  def add_outstanding_balance(amount)
    self.outstanding_balance += amount
    save!
  end
end