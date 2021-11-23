class UsersController < ApplicationController
  before_action :set_user, only: :destroy

  def destroy
      @user = User.find(params[:id]) 
      @user.destroy
      flash[:notice] = 'ユーザーを削除しました。'
      redirect_to :root #削除に成功すればrootページに戻る
  end

  private
  def set_user
     @user = User.find_by(:id => params[:id])
  end
end
