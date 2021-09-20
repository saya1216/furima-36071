class ItemsController < ApplicationController
  def index
    @items = Item.order('created_at DESC')
  end

  def new
    @item = Item.new
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      redirect_to root_path
    else
      render :new
    end
  end

  private

  def item_params
    params.require(:item).permit(:item_name, :information, :image, :category_id, :sales_status_id, :shipping_cost_id,
                                 :prefecture_id, :shipping_days_id, :price).merge(user_id: current_user.id)
  end
end
