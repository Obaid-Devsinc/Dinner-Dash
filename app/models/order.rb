class Order < ApplicationRecord
  STATUSES = %w[ordered paid completed cancelled].freeze

  belongs_to :user, counter_cache: true
  has_many :order_items, dependent: :destroy

  enum :status, { ordered: "ordered", paid: "paid", completed: "completed", cancelled: "cancelled" }

  default_scope { order(created_at: :desc) }
  scope :by_status, ->(status) { where(status: status) }
  scope :with_items_count, -> { left_joins(:order_items).select("orders.*, COUNT(order_items.id) AS order_items_count").group(:id) }

  validates :user, presence: true
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :phone, presence: true, length: { is: 11 }
  validates :first_name, :last_name, :address, :city, :zip, presence: true
  validates :zip, format: { with: /\A\d{4,10}\z/, message: "Must be a valid ZIP code" }
  validates :total_amount, presence: true, numericality: { greater_than_or_equal_to: 0 }

  # -------------------------------
  # Manual state machine
  # -------------------------------

  def ordered?; status == "ordered"; end
  def paid?; status == "paid"; end
  def completed?; status == "completed"; end
  def cancelled?; status == "cancelled"; end

  def mark_paid!
    raise "Only ordered orders can be marked as paid" unless ordered?
    update!(status: "paid")
  end

  def complete_order!
    raise "Only paid orders can be marked as completed" unless paid?
    update!(status: "completed")
  end

  def cancel_order!
    raise "Only ordered or paid orders can be cancelled" unless ordered? || paid?
    update!(status: "cancelled")
  end
end
