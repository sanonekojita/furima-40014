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

  #空の投稿を保存できないようにする
  validates :item_name, :item_info, presence: true

  #ジャンルの選択が「---」の時は保存できないようにする
  validates :category_id, numericality: { other_than: 1 , message: "can't be blank"}

end
