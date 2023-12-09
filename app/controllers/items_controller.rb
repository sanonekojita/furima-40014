class ItemsController < ApplicationController
  before_action :move_to_sign_in, except: :index

  def index
  end

  def new
    @item = Item.new
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      redirect_to root_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def item_params
    params.require(:item).permit(:item_name, :item_info,
                                 :category_id, :sales_status_id,
                                 :shipping_fee_status_id, :prefecture_id,
                                 :scheduled_delivery_id, :item_price, :image).merge(user_id: current_user.id)
  end

  def move_to_sign_in
    return if user_signed_in?

    redirect_to new_user_session_path, notice: 'You need to sign in or sign up before continuing.'
  end
end
