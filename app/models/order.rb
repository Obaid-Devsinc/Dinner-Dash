class Order < ApplicationRecord
  belongs_to :user, counter_cache: true
  has_many :order_items, dependent: :destroy

  enum :status, { paid: "paid", ordered: "ordered", completed: "completed", cancelled: "cancelled" }

  default_scope { order(created_at: :desc) }

  validates :user, presence: true
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :phone, presence: true, length: { is: 11 }
  validates :first_name, :last_name, :address, :city, :zip, presence: true
  validates :zip, format: { with: /\A\d{4,10}\z/, message: "Must be a valid ZIP code" }
  validates :total_amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
