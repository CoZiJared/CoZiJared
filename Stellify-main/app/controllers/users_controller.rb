class UsersController < ApplicationController
  before_action :authenticate_user!

  def explore
    redirect_to user_path(User.find(User.pluck(:id).sample))
  end

  def index
    @likes = current_user.likes
  end

  def show
    @user = User.find(params[:id])
  end
end
