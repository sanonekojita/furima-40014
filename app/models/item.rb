class Item < ApplicationRecord
  belongs_to :user
  has_one :purchase_record
  has_many_attached :images
  has_many :likes
  has_many :comments
  has_many :categories
  acts_as_taggable

  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :sales_status, class_name: 'SalesStatus'
  belongs_to :shipping_fee_status, class_name: 'ScheduledDelivery'
  belongs_to :prefecture
  belongs_to :scheduled_delivery, class_name: 'ShippingFeeStatus'

  validates :images, presence: true, length: { in: 1..5, message: 'must be at least 1 and no more than 5' }
  validates :item_name, :item_info, :item_price, presence: true

  # validates :item_name, presence: true, length: { minimum: 1, maximum: 40 }
  # validates :item_info, presence: true, length: { minimum: 1, maximum: 1000 }

  DECIMAL_REGEX = /\A\d+(\.\d+)?\s*\z/
  validates :item_price, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 300,
    less_than_or_equal_to: 9_999_999,
    message: lambda do |_object, data|
               if data[:value].blank?
                 'is not a number'
               elsif data[:value].to_i.to_s == data[:value].to_s && data[:value].to_i < 300
                 'must be greater than or equal to 300'
               elsif data[:value].to_i.to_s == data[:value].to_s && data[:value].to_i > 9_999_999
                 'must be less than or equal to 9999999'
               elsif data[:value].to_s.match?(DECIMAL_REGEX)
                 'must be an integer'
               else
                 'is not a number'
               end
             end
  }

  validate :validate_category_presence

  validates :sales_status_id, :shipping_fee_status_id, :prefecture_id, :scheduled_delivery_id,
            numericality: { other_than: 1, message: "can't be blank" }

  def liked_by?(user)
    likes.where(user_id: user.id).exists?
  end

  private

  def validate_category_presence
    return if category_id.present? && child_category_id.present? && grandchild_category_id.present?

    errors.add(:base, 'カテゴリーは未選択にできません')
  end
end
