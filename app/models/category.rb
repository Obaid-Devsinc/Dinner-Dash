class Category < ApplicationRecord
  has_many :items, dependent: :destroy
  has_one_attached :image, dependent: :purge_later

  before_validation :generate_slug, on: :create

  default_scope { order(created_at: :desc) }

  validates :slug, uniqueness: true, presence: true
  validates :name, presence: true, uniqueness: { case_sensitive: false }

  #  def to_param
  #   slug
  #  end

  private

  def generate_slug
    self.slug ||= name.parameterize
  end
end
