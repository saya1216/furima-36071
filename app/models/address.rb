class Address < ApplicationRecord

  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :order
  has_one :prefecture

end
