class Public::HomesController < ApplicationController
  
  def top
    @genres = Genre.all
    @items = Item.where.not(is_active: "false").order(created_at: :desc)

  end
  
end
