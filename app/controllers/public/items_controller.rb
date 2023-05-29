class Public::ItemsController < ApplicationController

  
  def index
    @items = Item.where.not(is_active: "false").page(params[:page])
    @items_count = Item.count
    @genres = Genre.all
  end
  
  def show
    @genres = Genre.all
    @item =Item.find(params[:id])
    @cart_item = CartItem.new
  end
  
  
end
