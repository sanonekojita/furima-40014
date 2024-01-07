class PurchaseRecordShippingAddress
  include ActiveModel::Model
  attr_accessor :postal_code, :prefecture_id, :city, :addresses, :building, :phone_number, :item_id, :user_id,
                :token

  validates :token, presence: true, unless: :card_already_registered?
  with_options presence: true do
    validates :user_id, :item_id
    validates :postal_code, format: { with: /\A[0-9]{3}-[0-9]{4}\z/, message: 'is invalid. Enter it as follows (e.g. 123-4567)' }
    validates :prefecture_id, numericality: { other_than: 1, message: "can't be blank" }
    validates :city, :addresses
    validates :phone_number, length: { minimum: 10, maximum: 11, too_short: 'is too short', too_long: 'is too long' },
                             format: { with: /\A[0-9]+\z/, message: 'is invalid. Input only number' }
  end

  validate :validate_item_uniqueness

  def save
    purchase_record = PurchaseRecord.create(item_id:, user_id:)
    ShippingAddress.create(postal_code:, prefecture_id:, city:, addresses:,
                           building:, phone_number:, purchase_record_id: purchase_record.id)
  end

  private

  def validate_item_uniqueness
    return unless item_id.present? && PurchaseRecord.exists?(item_id:)

    errors.add(:item_id, 'has already been taken')
  end

  def initialize(attributes = {}, user = nil)
    super(attributes)
    @user = user
  end

  def card_already_registered?
    @user&.card.present?
  end
end
