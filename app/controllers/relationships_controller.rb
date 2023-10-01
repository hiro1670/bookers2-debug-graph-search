class RelationshipsController < ApplicationController
  before_action :authenticate_user!
  def create
    current_user.follow(params[:user_id])
    redirect_to request.referer || root_path
  end
  
  def destroy
    current_user.unfollow(params[:user_id])
    redirect_to request.referer || root_path
  end
end
