class StoreController < ApplicationController
  def index
  	@meus_produtos = Product.order(:title)
  	@cart = current_cart  
  end
end
