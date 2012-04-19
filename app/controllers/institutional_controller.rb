class InstitutionalController < ApplicationController
  def home
  	@puts = Order.all
  end
end
