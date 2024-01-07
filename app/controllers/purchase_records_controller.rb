# class PurchaseRecordsController < ApplicationController
#   before_action :set_item, only: [:index, :create]
#   before_action :move_to_sign_in

#   def index
#     gon.public_key = ENV['PAYJP_PUBLIC_KEY']
#     @purchase_record_shipping_address = PurchaseRecordShippingAddress.new

#     if user_signed_in? && current_user.id == @item.user_id || !PurchaseRecord.exists?(item_id: @item.id)
#       @card = current_user.card
#       return unless @card.present?

#       # クレジットカード情報を表示する処理
#       customer = Payjp::Customer.retrieve(@card.customer_token)
#       @card_info = customer.cards.first if customer.cards.present?
#     else
#       redirect_to root_path
#       nil
#     end
#   end

#   def create
#     @purchase_record_shipping_address = PurchaseRecordShippingAddress.new(purchase_record_params)

#     if @purchase_record_shipping_address.valid?
#       if params[:purchase_record_shipping_address][:save_card] == "true"
#         Payjp.api_key = ENV["PAYJP_SECRET_KEY"] # 環境変数を読み込む
#         customer = Payjp::Customer.create(
#           description: 'test', # テストカードであることを説明
#           card: purchase_record_params[:token] # 登録しようとしているカード情報
#         )
#         card = Card.new( # 顧客トークンとログインしているユーザーを紐付けるインスタンスを生成
#         token: purchase_record_params[:token],  #カード情報
#         customer_token: customer.id, # 顧客トークン
#         user_id: current_user.id # ログインしているユーザー
#         )
#         save_card_info # メソッドの呼び出し
#       end

#       pay_item
#       @purchase_record_shipping_address.save
#       redirect_to root_path
#     else
#       gon.public_key = ENV['PAYJP_PUBLIC_KEY']
#       render  'purchase_records/index', status: :unprocessable_entity
#     end
#   end

#   private

#   def set_item
#     @item = Item.find(params[:item_id])
#   end

#   def purchase_record_params
#     params.require(:purchase_record_shipping_address)
#           .permit(:postal_code, :prefecture_id, :city, :addresses, :building, :phone_number)
#           .merge(user_id: current_user.id, item_id: @item.id, token: params[:token])
#   end

#   def save_card_info
#     Payjp::Charge.create(
#       amount: @item.item_price,
#       card: purchase_record_params[:token],
#       currency: 'jpy'
#     )
#   end

#   def pay_item
#     Payjp.api_key = ENV['PAYJP_SECRET_KEY']
#     customer_token = current_user.card.customer_token
#     Payjp::Charge.create(
#       amount: @item.item_price,
#       customer: customer_token, # 顧客のトークン
#       currency: 'jpy'
#     )
#   end

#   def move_to_sign_in
#     return if user_signed_in?

#     redirect_to new_user_session_path, notice: 'ログインまたはアカウント登録が必要です。続行する前にサインインまたはサインアップしてください。'
#   end
# end


class PurchaseRecordsController < ApplicationController
  before_action :set_item, only: [:index, :create]
  before_action :move_to_sign_in

  def index
    gon.public_key = ENV['PAYJP_PUBLIC_KEY']
    @purchase_record_shipping_address = PurchaseRecordShippingAddress.new

    if user_signed_in? && current_user.id == @item.user_id || !PurchaseRecord.exists?(item_id: @item.id)
      @card = current_user.card
      return unless @card.present?

      customer = Payjp::Customer.retrieve(@card.customer_token)
      @card_info = customer.cards.first
    else

      redirect_to root_path
    end
  end

  def create
    @purchase_record_shipping_address = PurchaseRecordShippingAddress.new(purchase_record_params, current_user)
    @card = current_user.card

    if @card.present?
      customer = Payjp::Customer.retrieve(@card.customer_token)
      @card_info = customer.cards.first
    end

    Payjp.api_key = ENV['PAYJP_SECRET_KEY']

    # クレジットカード情報がある場合はそれを使用して支払いを行う
    if @card_info.present?
      @customer_token = current_user.card.customer_token
    else
      @customer_token = create_customer1(purchase_record_params[:token])
      # @customer_token = purchase_record_params[:token] # @purchase_record_shipping_address.token
    end

    if @purchase_record_shipping_address.valid?
      if params[:purchase_record_shipping_address][:save_card] == "true"
        # クレジットカード情報のトークン化と顧客の作成
        customer = Payjp::Customer.retrieve(@customer_token)
        save_card_info(customer.id, purchase_record_params[:token])

        pay_item
        @purchase_record_shipping_address.save
        redirect_to root_path
      elsif purchase_record_params[:token].present?

        pay_item
        @purchase_record_shipping_address.save
        redirect_to root_path
      else

        pay_item
        @purchase_record_shipping_address.save
        redirect_to root_path
      end
    else
      gon.public_key = ENV['PAYJP_PUBLIC_KEY']
      @card = current_user.card

      if @card.present?
        customer = Payjp::Customer.retrieve(@card.customer_token)
        @card_info = customer.cards.first if customer.cards.present?
      end

      render 'purchase_records/index', status: :unprocessable_entity
    end
  end

  private

  def set_item
    @item = Item.find(params[:item_id])
  end

  def purchase_record_params
    params.require(:purchase_record_shipping_address)
          .permit(:postal_code, :prefecture_id, :city, :addresses, :building, :phone_number)
          .merge(user_id: current_user.id, item_id: @item.id, token: params[:token])
  end

  def create_customer1(token)
    Payjp.api_key = ENV['PAYJP_SECRET_KEY']
    customer = Payjp::Customer.create(
      description: 'test', # テストカードであることを説明
      card: token
    )
    customer.id # 顧客トークンを返す
  end

  def create_customer2(token)
    Payjp.api_key = ENV['PAYJP_SECRET_KEY']
    Payjp::Customer.create(
      description: 'test', # テストカードであることを説明
      card: token
    )
  end

  def save_card_info(customer_id, token)
    # 顧客トークンとログインしているユーザーを紐付けるインスタンスを生成
    card = Card.new(
      token: token, # カード情報
      customer_token: customer_id, # 顧客トークン
      user_id: current_user.id # ログインしているユーザー
    )
    card.save
  end

  def pay_item
    Payjp::Charge.create(
      amount: @item.item_price,
      customer: @customer_token, # 顧客のトークン
      currency: 'jpy'
    )
  end

  def move_to_sign_in
    return if user_signed_in?

    redirect_to new_user_session_path, notice: 'ログインまたはアカウント登録が必要です。続行する前にサインインまたはサインアップしてください。'
  end
end
