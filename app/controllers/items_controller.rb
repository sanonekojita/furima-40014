class ItemsController < ApplicationController
  before_action :set_item, only: [:show, :edit, :update]
  before_action :move_to_sign_in, except: [:index, :show]
  before_action :set_maincategories, only: [:new, :create]

  def index
    @items = Item.all.order('created_at DESC').page(params[:page]).per(15)
  end

  def new
    @item = Item.new
    @maincategories = Category.where(ancestry: nil)
  end

  def create
    @item = Item.new(item_params)
    @item.tag_list.add(params[:tag_list], parse: true)
    if @item.save
      redirect_to root_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @comments = @item.comments.includes(:user)
    @comment = Comment.new
  end

  def edit
    @maincategories = Category.where(ancestry: nil)
    return if user_signed_in? && current_user.id == @item.user_id && !PurchaseRecord.exists?(item_id: @item.id)

    redirect_to action: :index
  end

  def update
    @maincategories = Category.where(ancestry: nil)

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

  def search
    # params[:q]がnilではない且つ、params[:q][:name]がnilではないとき（商品名の欄が入力されているとき）
    # if params[:q] && params[:q][:name]と同じような意味合い
    if params[:q]&.dig(:item_name)
      # squishメソッドで余分なスペースを削除する
      squished_keywords = params[:q][:item_name].squish
      ## 半角スペースを区切り文字として配列を生成し、paramsに入れる
      params[:q][:item_name_cont_any] = squished_keywords.split(' ')
    end
    @q = Item.ransack(params[:q])
    @items = @q.result
  end

  def tag_search
    tags = ActsAsTaggableOn::Tag.where('name LIKE ?', "%#{params[:q]}%")
    render json: { tags: tags.pluck(:name) }
  end

  private

  def set_item
    @item = Item.find(params[:id])
  end

  def item_params
    params.require(:item).permit(:item_name, :item_info,
                                 :sales_status_id, :shipping_fee_status_id,
                                 :prefecture_id, :scheduled_delivery_id,
                                 :item_price, :category_id,
                                 :child_category_id, :grandchild_category_id,
                                 :tag_list, { images: [] }).merge(user_id: current_user.id)
  end

  def move_to_sign_in
    return if user_signed_in?

    redirect_to new_user_session_path, notice: 'ログインまたはアカウント登録が必要です。続行する前にサインインまたはサインアップしてください。'
  end

  def set_maincategories
    @maincategories = Category.where(ancestry: nil)
  end
end
