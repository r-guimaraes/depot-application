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
		assert_equal "must be greater than or equal to 0.01 | negative price", coke.errors[:price].join('; ')

		coke.price = 0
		assert coke.invalid?
		assert_equal "must be greater than or equal to 0.01 | price = 0", coke.errors[:price].join('; ')

		coke.price = 2
		assert coke.invalid?
		assert_equal "must be greater than or equal to 0.01 | price > 0", coke.errors[:price].join('; ')
	end
	def novo_produto(sent_image)
		Product.new(:title => "Leitbom",
					:description => "Healthy stuff for all your family! ;)",
					:price => 1.99,
					:image_url => sent_image)
	end
	test "check sent image's file format" do
		ok  = %w{b.gif b.jpg b.png B.gif B.JPG B.Jpg http://abc.s.a/why/as/fred.gif}
		bad = %w{b.doc b.gif/more b.gif.more}
		ok.each do |name|
			assert novo_produto(name).valid?, "#{name} should not be invalid"
		end
		bad.each do |name|
			assert novo_produto(name).valid?, "#{name} should not be valid"
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
