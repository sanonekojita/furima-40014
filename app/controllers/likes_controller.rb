class LikesController < ApplicationController
  before_action :set_item

  def create
    like = current_user.likes.build(item_id: params[:item_id])
    like.save
    respond_to(&:js)
  end

  def destroy
    like = Like.find_by(item_id: params[:item_id], user_id: current_user.id)
    like.destroy
    respond_to(&:js)
  end

  private

  def set_item
    @item = Item.find(params[:item_id])
  end
end
