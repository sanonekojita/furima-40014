class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @items = @user.items.page(params[:page]).per(15)

    if user_signed_in?
      Payjp.api_key = ENV['PAYJP_SECRET_KEY']
      @card = Card.find_by(user_id: @user.id)

      if @card.present? && @card.customer_token.present?
        customer = Payjp::Customer.retrieve(@card.customer_token)
        @card_info = customer.cards.first if customer.cards.present?
        # 以降の処理（顧客情報およびカード情報が存在する場合の処理）
      end
    else
      # ログインしていない場合の処理（例: ログインページへのリダイレクト）
      redirect_to new_user_session_path, notice: 'ログインまたはアカウント登録が必要です。続行する前にサインインまたはサインアップしてください。'
    end
  end

  def update
    if current_user.update(user_params) # 更新出来たかを条件分岐する
      redirect_to root_path # 更新できたらrootパスへ
    else
      redirect_to action: 'show' # 失敗すれば再度マイページへ
    end
  end

  def edit
  end

  private

  def user_params
    params.require(:user).permit(:nickname, :email) # 編集出来る情報を制限
  end
end
