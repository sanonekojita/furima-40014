class Item < ApplicationRecord
  belongs_to :user
  # has_one :purchase_record
  has_one_attached :image

  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :category
  belongs_to :sales_status, class_name: 'SalesStatus'
  belongs_to :shipping_fee_status, class_name: 'ScheduledDelivery'
  belongs_to :prefecture
  belongs_to :scheduled_delivery, class_name: 'ShippingFeeStatus'

  validates :image, :item_name, :item_info, :item_price, presence: true
  # validates :item_name, presence: true, length: { minimum: 1, maximum: 40 }
  # validates :item_info, presence: true, length: { minimum: 1, maximum: 1000 }

  DECIMAL_REGEX = /\A\d+(\.\d+)?\s*\z/
  validates :item_price, numericality: {
  only_integer: true,
  greater_than_or_equal_to: 300,
  less_than_or_equal_to: 9999999,
  message: ->(object, data) do
    if data[:value].blank?
      'is not a number'
    elsif data[:value].to_i.to_s == data[:value].to_s && data[:value].to_i < 300
      "must be greater than or equal to 300"
    elsif data[:value].to_i.to_s == data[:value].to_s && data[:value].to_i > 9999999
      "must be less than or equal to 9999999"
    elsif data[:value].to_s.match?(DECIMAL_REGEX)
      'must be an integer'
    else
      'is not a number'
    end
  end
  }

  validates :category_id, :sales_status_id, :shipping_fee_status_id, :prefecture_id, :scheduled_delivery_id, numericality: { other_than: 1 , message: "can't be blank"}

end
