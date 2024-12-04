class Customer < ApplicationRecord
  has_many :subscriptions, dependent: :destroy

  # Validations
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :phone, presence: true, format: { with: /\A\+?[\d\s\-()]*\z/, message: "only allows numbers, spaces, and certain symbols" }
end