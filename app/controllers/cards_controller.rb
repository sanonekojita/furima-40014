class CardsController < ApplicationController
  def new
    gon.public_key = ENV['PAYJP_PUBLIC_KEY']
    redirect_to root_path if user_signed_in? && current_user.card
  end

  def create
    Payjp.api_key = ENV['PAYJP_SECRET_KEY'] # 環境変数を読み込む
    customer = Payjp::Customer.create(
      description: 'test', # テストカードであることを説明
      card: params[:token] # 登録しようとしているカード情報
    )
    card = Card.new( # 顧客トークンとログインしているユーザーを紐付けるインスタンスを生成
      token: params[:token], # カード情報
      customer_token: customer.id, # 顧客トークン
      user_id: current_user.id # ログインしているユーザー
    )
    if card.save
      redirect_to user_path(current_user)
    else
      redirect_to action: 'new' # カード登録画面へリダイレクト
    end
  end

  def edit
    gon.public_key = ENV['PAYJP_PUBLIC_KEY']
    @card = Card.find(params[:id])
  end

  def update
    Payjp.api_key = ENV['PAYJP_SECRET_KEY']

    @card = Card.find(params[:id])

    # 顧客情報を取得
    customer = Payjp::Customer.retrieve(@card.customer_token)

    # カード情報を新しく追加
    new_card_token = params[:token] # 新しいトークンを取得

    if new_card_token.present?
      # 顧客情報を更新
      customer.card = new_card_token
      customer.save

      # カード情報をデータベースに保存
      if @card.update(
        token: new_card_token,
        customer_token: customer.id,
        user_id: current_user.id # ユーザーIDを追加
      )
        redirect_to user_path(current_user), notice: 'カード情報が更新されました。'
      else
        flash[:alert] = 'カード情報の更新に失敗しました。'
        redirect_to edit_card_path
      end
    else
      flash[:alert] = '新しいカード情報のトークンがありません。'
      redirect_to edit_card_path
    end
  end

  def destroy
    @card = Card.find(params[:id])

    return unless user_signed_in? && current_user.id == @card.user_id

    @card.destroy
    redirect_to user_path(current_user)
  end

  private

  def card_params
    params.require(:card).permit(:token, :customer_token, :other_attribute)
  end
end
