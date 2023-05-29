module Public::ItemsHelper
  
  # 税込価格（10%）小数点以下切り捨て
  def price_with_tax(price)
    (price * 1.1).floor
  end
  
end
