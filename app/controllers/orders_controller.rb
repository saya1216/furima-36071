class OrdersController < ApplicationController
  before_action :authenticate_user!

  def index
    #@item = Item.find(params[:item_id])
  end

  def create

  end
end
