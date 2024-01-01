class ItemsController < ApplicationController
  before_action :set_item, only: [:show, :edit, :update]
  before_action :move_to_sign_in, except: [:index, :show]

  def index
    @items = Item.all.order('created_at DESC')
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

  def show
  end

  def edit
    return if user_signed_in? && current_user.id == @item.user_id && !PurchaseRecord.exists?(item_id: @item.id)

    redirect_to action: :index
  end

  def update
    if @item.update(item_params)
      redirect_to item_path(@item)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    item = Item.find(params[:id])

    return unless user_signed_in? && current_user.id == item.user_id

    item.destroy
    redirect_to root_path
  end

  private

  def set_item
    @item = Item.find(params[:id])
  end

  def item_params
    params.require(:item).permit(:item_name, :item_info,
                                 :category_id, :sales_status_id,
                                 :shipping_fee_status_id, :prefecture_id,
                                 :scheduled_delivery_id, :item_price, {images: []}).merge(user_id: current_user.id)
  end

  def move_to_sign_in
    return if user_signed_in?

    redirect_to new_user_session_path, notice: 'ログインまたはアカウント登録が必要です。続行する前にサインインまたはサインアップしてください。'
  end
end
