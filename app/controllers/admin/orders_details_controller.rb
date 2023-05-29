class Admin::OrdersDetailsController < ApplicationController
    before_action :authenticate_admin!
  
  
  def update
    @order_detail = OrderDetail.find(params[:id])
    @order_detail.update(order_detail_params)
    @order = @order_detail.order
    
    @order_details = @order.order_details
    # 製作ステータスが全て製作完了となったら注文ステータスを発送準備中へ
    if @order_details.all? { |order_detail| order_detail.making_status == "production_completed" }
      @order.update(status: "reparing_for_shipping")
    # 製作ステータスが一つでも製作中となったら注文ステータスを製作中へ
    elsif @order_details.any? { |order_detail| order_detail.making_status == "in_production" }
      @order.update(status: "in_production")
      
    # elsif @order_detail.order.status == "payment_confirmed" 
    #   @order_detail.update(making_status: "waiting_for_production")
      
    end
    redirect_to edit_admin_order_path(@order)
  end
  
  
  def order_detail_params
    params.require(:order_detail).permit(:item_id, :order_id, :price, :amount, :making_status)
  end
  

  
end
