class StoreController < ApplicationController
  def index
  	@meus_produtos = Product.order(:title)
  end
end
