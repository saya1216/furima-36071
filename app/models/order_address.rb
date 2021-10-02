class OrderAddress
  include ActiveModel::Model
  attr_accessor :user_id, :item_id, :postal_code, :prefecture, :city, :house_number, :building, :telephone, :order_id

  with_options presence: true do
    validates :user_id
    validates :item_id
    validates :postal_code, format: {with: /\A\d{3}-\d{4}\z/, message: "is invalid. Include hyphen(-)"}
    validates :city
    validates :house_number
    validates :telephone, numericality: true, format: {with: /\A0\d{9,10}\z/}
    validates :order_id
  end
  validates :prefecture, numericality: {other_than: 1, message: "can't be blank"}
end
