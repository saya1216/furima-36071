class BuyerAddress
  include ActiveModel::Model
  attr_accessor :user_id, :item_id, :postal_code, :prefecture, :city, :house_number, :building, :telephone, :buyer_id

  with_options presence: true do
    validates :user_id
    validates :item_id
    validates :postal_code, format: {with: /\A[0-9]{3}-[0-9]{4}\z/, message: "is invalid. Include hyphen(-)"}
    validates :city
    validates :house_number
    validates :telephone
    validates :buyer_id
  end
  validates :prefecture, numericality: {other_than: 1, message: "can't be blank"}
end
