class Item < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions

  validates :image, presence: true
  validates :item_name, presence: true, length: { maximum: 40 }
  validates :information, presence: true, length: { maximum: 1_000 }
  validates :category_id, numericality: { other_than: 1, message: "を入力してください" }
  validates :sales_status_id, numericality: { other_than: 1, message: "を入力してください" }
  validates :shipping_cost_id, numericality: { other_than: 1, message: "を入力してください" }
  validates :prefecture_id, numericality: { other_than: 1, message: "を入力してください" }
  validates :shipping_days_id, numericality: { other_than: 1, message: "を入力してください" }
  validates :price, presence: true, format: { with: /\A[0-9]+\z/ },
                    numericality: { only_integer: true, greater_than_or_equal_to: 300, less_than_or_equal_to: 9_999_999 }

  belongs_to :user
  belongs_to :category
  belongs_to :prefecture
  belongs_to :sales_status
  belongs_to :shipping_cost
  belongs_to :shipping_days
  has_one_attached :image
  has_one :order
end
