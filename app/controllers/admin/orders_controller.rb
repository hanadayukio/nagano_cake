class Admin::OrdersController < ApplicationController
    before_action :authenticate_admin!
  
  def edit
    @order = Order.find(params[:id]) 
    @order_detail = @order.order_details
    @total = 0
    @total = @order.billing_amount - @order.postage
  end
  
  def update
    @order = Order.find(params[:id]) 
    @order.update(order_params)
    redirect_to edit_admin_order_path(@order)
    
    @order_details = @order.order_details
    
    if @order.status == "payment_confirmed" 
      @order_details.update(making_status: "waiting_for_production")
    end
  end
  
  
  def order_params
    params.require(:order).permit(:customer_id, :billing_amount, :postage, :status, :payment_method, :address, :postal_code, :name)
  end
  
end
