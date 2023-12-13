class PurchaseRecordsController < ApplicationController

  def index
    @item = Item.find(params[:item_id])
    @purchase_record_shipping_address = PurchaseRecordShippingAddress.new
  end

  def create
    @item = Item.find(params[:item_id])
    @purchase_record_shipping_address = PurchaseRecordShippingAddress.new(purchase_record_params)

    if @purchase_record_shipping_address.valid?
      @purchase_record_shipping_address.save
      redirect_to root_path
    else
      render  'purchase_records/index', status: :unprocessable_entity
    end
  end

  private

  def purchase_record_params
    params.require(:purchase_record_shipping_address).permit(:postal_code, :prefecture_id, :city, :addresses, :building, :phone_number).merge(user_id: current_user.id).merge(item_id: @item.id)
  end

end
