class RelationshipsController < ApplicationController

  def create
    follow = current_user.active_relationships.new(follower_id: params[:user_id])
    follow.save
    if request.referer && request.referer.include?("items")
      redirect_to item_path(params[:item_id])
    else
      redirect_to user_path(params[:user_id])
    end
  end

  def destroy
    follow = current_user.active_relationships.find_by(follower_id: params[:user_id])
    follow.destroy
    if request.referer && request.referer.include?("items")
      redirect_to item_path(params[:item_id])
    else
      redirect_to user_path(params[:user_id])
    end
  end

end
