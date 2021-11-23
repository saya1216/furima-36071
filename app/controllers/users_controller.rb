class UsersController < ApplicationController
  
  before_action :set_user, only: [:index, :destroy]

  def index
    @user = User.find(params[:id])
  end

  def destroy
    @user = User.find(params[:id]) 
    @user.destroy
    flash[:notice] = 'ありがとうございました。またのご利用を心よりお待ちしております。'
    redirect_to :root #削除に成功すればrootページに戻る
  end

  private
  def set_user
     @user = User.find_by(:id => params[:id])
  end
end
