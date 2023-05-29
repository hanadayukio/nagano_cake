class Public::OrdersController < ApplicationController
  before_action :authenticate_customer!
  
  def new
    @order = Order.new
  end
  
  def confirm
    @cart_items = current_customer.cart_items
    @order = Order.new(order_params)
    @total = (0)
    @order.customer_id = current_customer.id
    @order.status = (0)
    @order.billing_amount = @total
    @order.postage = (800)
    
    @cart_items.each do |cart_item|
      @total += (cart_item.item.price * 1.1).floor * cart_item.amount
    end
    @order.billing_amount = @total + @order.postage

    delivery_address = params[:order][:delivery_address].to_i
    address_id = params[:order][:address_id].to_i
    # ログインユーザ住所
    if delivery_address == 0
      @order.postal_code = current_customer.postal_code
      @order.name = current_customer.last_name + current_customer.first_name 
      @order.address = current_customer.address
    # 登録済み住所
    elsif delivery_address == 1
      @address = Address.find_by(id: address_id)
      @order.postal_code = @address.postal_code
      @order.name = @address.name
      @order.address = @address.address
    # 新規住所
    elsif delivery_address == 2
      
    end
    session[:order_data] = @order.attributes
  end

  def create
    @order = Order.new(session[:order_data])
    @order.save

    @cart_items = current_customer.cart_items

    @cart_items.each do |cart_item|
      @order_detail = OrderDetail.new
    
      @order_detail.order_id = @order.id
      @order_detail.item_id = cart_item.item_id
      @order_detail.price = (cart_item.item.price * 1.1).floor
      @order_detail.amount = cart_item.amount
      @order_detail.making_status = 0
      @order_detail.save!
    end

    current_customer.cart_items.destroy_all

    redirect_to complete_public_order_path(@order.id)
  end

  def index
    @orders = Order.all
  end

  def show
    @order = Order.find(params[:id])
    @total = @order.billing_amount - @order.postage
  end

  private
  
  def order_detail_params
    params.require(:order_detail).permit(:item_id, :order_id, :price, :amount, :making_status)
  end
  
  def order_params
    params.require(:order).permit(:customer_id, :billing_amount, :postage, :status, :payment_method, :address, :postal_code, :name)
  end


  
end
