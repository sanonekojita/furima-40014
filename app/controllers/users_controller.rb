class UsersController < ApplicationController

  def show
    if user_signed_in?
      Payjp.api_key = ENV["PAYJP_SECRET_KEY"]
      card = Card.find_by(user_id: current_user.id)

      if card.present? && card.customer_token.present?
        customer = Payjp::Customer.retrieve(card.customer_token)
        @card = customer.cards.first if customer.cards.present?
        # 以降の処理（顧客情報およびカード情報が存在する場合の処理）
      else
        # カード情報または顧客情報が存在しない場合の処理
      end
    else
      # ログインしていない場合の処理（例: ログインページへのリダイレクト）
      redirect_to new_user_session_path
    end
  end

  def update
    if current_user.update(user_params) # 更新出来たかを条件分岐する
      redirect_to root_path # 更新できたらrootパスへ
    else
      redirect_to action: "show" # 失敗すれば再度マイページへ
    end
  end

  def edit

  end

  private

  def user_params
    params.require(:user).permit(:nickname, :email) # 編集出来る情報を制限
  end

end
