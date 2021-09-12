class Item < ApplicationRecord

  validates :image, presence: true
  validates :item_name, presence: true
  validates :information, presence: true
  validates :category_id, presence: true
  validates :sales_status_id, presence: true
  validates :shipping_cost_id, presence: true
  validates :prefecture_id, presence: true
  validates :shipping_days_id, presence: true
  validates :price_id, presence: true

  belongs_to :user
  has_one_attached :image

end
