require 'test_helper'

class ProductTest < ActiveSupport::TestCase
	fixtures :products

	test "user can not insert blank product row" do
		produto = Product.new
		assert produto.invalid?
		assert produto.errors[:title].any?
		assert produto.errors[:description].any?
		assert produto.errors[:image_url].any?
		assert produto.errors[:price].any?
	end
	test "products price must be a positive integer" do
		coke = Product.new(title: "Coca Cola Light", description: "try it out", image_url: "coke.gif")
		coke.price = -5
		assert coke.invalid?
		# assert_equal "must be lesser than 0.05 | negative price", coke.errors[:price].join('; ')

		coke.price = 0
		assert coke.invalid?
		# assert_equal "must be equal to 0.05 | price = 0", coke.errors[:price].join('; ')

		coke.price = 2
		assert coke.valid?
		# assert_equal "must be greater than or equal to 0.01 | price > 0", coke.errors[:price].join('; ')
	end
	def novo_produto(sent_image)
		Product.new(:title => "Leitbom",
					:description => "Healthy stuff for all your family! ;)",
					:price => 1.99,
					:image_url => sent_image)
	end
	test "checar formato de imagem enviada" do
		ok  = %w{fred.gif fred.jpg fred.png Fred.gif FRED.JPG FRED.Jpg http://a.b.c/why/as/fred.gif}
		bad = %w{fred.doc fred.gif/more fred.gif.more}
		ok.each do |name|
			assert novo_produto(name).valid?, "#{name} deveria ser valido"
		end
		bad.each do |name|
			assert novo_produto(name).invalid?, "#{name} nao deveria ser aceitado"
		end
	end
	test "product it not valid without a unique title - i18n" do
		product = Product.new(title: products(:ruby).title,
							  description: 'yaml rocks! infweb awesome',
							  price: 89.0,
							  image_url: "fred.gif")
		assert !product.save
		assert_equal I18n.translate('activerecord.errors.messages.taken'), product.errors[:title].join("; ")
	end
end
