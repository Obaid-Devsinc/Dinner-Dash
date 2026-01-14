class User < ApplicationRecord
  has_one :cart, dependent: :destroy
  has_many :orders, dependent: :destroy
  has_one_attached :image, dependent: :purge_later

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum :role, { customer: 0, admin: 1 }

  default_scope { order(created_at: :desc) }
  scope :customer, -> { where(role: 0) }
  scope :admin, -> { where(role: 1) }

  validates :name, presence: true, length: { minimum: 3, message: "Must be 3 alphabets" }
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP, message: "Must be a valid email address" }

  def admin?
    role == "admin"
  end
end
