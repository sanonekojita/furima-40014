class UserAddress < ApplicationRecord
  belongs_to :user, optional: true

  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :prefecture

  validates :user_postal_code, :user_city, :user_addresses,
            :user_building, :user_phone_number, presence: true

  # validates :prefecture_id, { other_than: 1, message: "can't be blank" }
end
