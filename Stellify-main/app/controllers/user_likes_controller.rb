class UserLikesController < ApplicationController
  before_action :authenticate_user!

  def like
    unless current_user.likes.exists?(id: params[:user_id])
      current_user.likes << User.find(params[:user_id])
    end

    redirect_to users_path
  end
end
