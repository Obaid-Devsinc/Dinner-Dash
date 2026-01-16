class Item < ApplicationRecord
  belongs_to :category, counter_cache: true
  has_many :order_items
  has_one_attached :image, dependent: :purge_later

  before_destroy :check_for_orders
  before_validation :generate_slug, on: :create


   default_scope { order(created_at: :desc) }
   scope :active, -> { where(retired: false) }
   scope :retired, -> { where(retired: true) }

   validates :category, presence: true
   validates :description, presence: true
   validates :slug, uniqueness: true, presence: true
   validates :title, presence: true, uniqueness: true
   validates :price, presence: true, numericality: { greater_than: 0 }

   def to_param
    slug
   end

  private

  def check_for_orders
    if order_items.exists?
      errors.add(:base, "Cannot delete an item that has existing orders")
      throw :abort
    end
  end

  def generate_slug
    self.slug ||= title.parameterize
  end
end
