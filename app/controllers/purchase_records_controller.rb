class PurchaseRecordsController < ApplicationController
  before_action :move_to_sign_in

  def index
    gon.public_key = ENV['PAYJP_PUBLIC_KEY']
    @item = Item.find(params[:item_id])
    @purchase_record_shipping_address = PurchaseRecordShippingAddress.new

    return unless user_signed_in? && current_user.id == @item.user_id || PurchaseRecord.exists?(item_id: @item.id)

    redirect_to root_path
    nil
  end

  def create
    @item = Item.find(params[:item_id])
    @purchase_record_shipping_address = PurchaseRecordShippingAddress.new(purchase_record_params)

    if @purchase_record_shipping_address.valid?
      pay_item
      @purchase_record_shipping_address.save
      redirect_to root_path
    else
      gon.public_key = ENV['PAYJP_PUBLIC_KEY']
      render  'purchase_records/index', status: :unprocessable_entity
    end
  end

  private

  def purchase_record_params
    params.require(:purchase_record_shipping_address)
          .permit(:postal_code, :prefecture_id, :city, :addresses, :building, :phone_number)
          .merge(user_id: current_user.id)
          .merge(item_id: @item.id)
          .merge(token: params[:token])
  end

  def pay_item
    Payjp.api_key = ENV['PAYJP_SECRET_KEY']
    Payjp::Charge.create(
      amount: @item.item_price,
      card: purchase_record_params[:token],
      currency: 'jpy'
    )
  end

  def move_to_sign_in
    return if user_signed_in?

    redirect_to new_user_session_path, notice: 'You need to sign in or sign up before continuing.'
  end
end
