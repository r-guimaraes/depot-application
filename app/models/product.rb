#encoding: utf-8
class Product < ActiveRecord::Base
  has_many :line_items

  before_destroy :ensure_not_referenced_by_any_line_item

  attr_accessible :description, :image_url, :price, :title

  validates :title, :description, :image_url, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0.50 , message: "Price can not be less than fifty cent | Formato Padrão: 00.00"}
  validates :title, uniqueness: true
  validates :image_url, allow_blank: true, format: { 
  	with: %r{\.(gif|jpg|png)$}i,
  	message: "Insira apenas imagens JPG, GIF ou PNG."
  }
  validates :description, length: 5..150

  private
  def ensure_not_referenced_by_any_line_item
  	if line_items.empty?
  		return true
  	else
  		errors.add(:base, 'Line Items present')
  		return false
  	end
  end
end
