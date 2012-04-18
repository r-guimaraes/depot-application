class LineItem < ActiveRecord::Base
  attr_accessible :cart_id, :product_id, :product, :quantity
  belongs_to :product
  belongs_to :cart 
  def total_price
  	return product.price * quantity
  end
end
