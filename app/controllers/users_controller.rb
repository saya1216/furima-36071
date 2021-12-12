class UsersController < ApplicationController
  before_action :set_user, only: [:index, :destroy]

  def index
    @user = User.find(params[:id])
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    flash[:success] = 'ありがとうございました。またのご利用を心よりお待ちしております。'
    redirect_to root_path
  end

  private

  def set_user
    @user = User.find_by(id: params[:id])
  end
end
