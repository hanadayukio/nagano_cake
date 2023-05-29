class Public::CartItemsController < ApplicationController
  before_action :authenticate_customer!

  def create
    # ログインしているユーザーのカートからcartitemのitemidを取り出す　presentで中身があるか判断
    if current_customer.cart_items.find_by(item_id: params[:cart_item][:item_id]).present?
      @cart_item = current_customer.cart_items.find_by(item_id: params[:cart_item][:item_id])
    # @cart_item.amount = @cart_item.amount + params[:cart_item][:amount].to_iの意味　すでにある個数に入力フォームから取得した数量をたす
      @cart_item.amount += params[:cart_item][:amount].to_i
      @cart_item.save
    else
      @cart_item = CartItem.new(cart_item_params)
      @cart_item.customer_id = current_customer.id
      @cart_item.save
    end
    
    redirect_to cart_items_path
  end
  

  
  def index
    @cart_items = current_customer.cart_items
    @total = 0
    @cart_items.each do |cart_item|
      @total += (cart_item.item.price * 1.1).floor * cart_item.amount
    end
  end
  
  
  def update
    @cart_items = CartItem.find(params[:id])
    @cart_items.update(cart_item_params)
    redirect_to cart_items_path
  end
  
  def destroy
    cart_item = CartItem.find(params[:id])
    cart_item.destroy
    redirect_to cart_items_path
  end
  
  def destroy_all
    CartItem.destroy_all
    current_customer.cart_items.destroy_all
    redirect_to cart_items_path
  end
  
  private
  
  def cart_item_params
    params.require(:cart_item).permit(:item_id, :customer_id, :amount)
  end
end
