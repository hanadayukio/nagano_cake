class Public::CustomersController < ApplicationController
  before_action :authenticate_customer!
  
  def show
    @customer = current_customer
  end
  
  def edit
    @customer = current_customer
  end
  
  def update
    @customer = current_customer
    @customer.update(customer_params)
    redirect_to home_path
  end

  def confirm
  end
  
  def withdraw
    @customer = current_customer
    @customer.update(is_deleted: false)
    reset_session
    redirect_to top_page_path
  end
  
  private
  def customer_params
    params.require(:customer).permit(:email, :last_name, :first_name, :last_name_kana, :first_name_kana, :postal_code, :address, :telephone_number, :is_deleted )
  end
  
end
