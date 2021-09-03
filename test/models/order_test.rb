require 'test_helper'

class OrderTest < ActiveSupport::TestCase

  test 'creates a random number on create' do
    user = User.create(email: "user@example.com", password: "12345678")
    order = Order.create(user_id: user.id)
    assert !order.number.nil?
  end

  test 'number must be unique' do
    user = User.create(email: "user@example.com", password: "12345678")
    order = Order.create(user_id: user.id)
    duplicated_order = order.dup
    assert_not duplicated_order.valid?
  end

  test 'add products as order_items' do
    user = User.create(email: "user@example.com", password: "12345678")
    order = Order.create(user_id: user.id)

    product = Product.create(name: "test", price: 1, stock: 10, sku: "001")
    color = Color.create(name: "red")
    size = Size.create(name: "XL")

    variant = Variant.create(product_id: product.id, color_id: color.id, size_id: size.id, stock: 10)
    
    order.add_product(variant.id, 1)

    assert_equal order.order_items.count, 1
  end

  test 'pass total price to cents' do
    user = User.create(email: "user@example.com", password: "12345678")
    order = Order.create(user_id: user.id, total: 100)

    assert_equal order.totalInCents, 10000
  end
  
  test 'order create a payment' do
    user = User.create(email: "user@example.com", password: "12345678")
    order = Order.create(user_id: user.id, total: 100)
    PaymentMethod.create(name: "Paypal", code: "PEC")

    order.create_payment("PEC", 'token_123456')
    assert_equal order.payments.count, 1

  end

  test 'new payment have processing state' do
    user = User.create(email: "user@example.com", password: "12345678")
    order = Order.create(user_id: user.id, total: 100)
    PaymentMethod.create(name: "Paypal", code: "PEC")

    order.create_payment("PEC", 'token_123456')
    assert_equal order.payments.first.state, "processing"
  end 

  test 'order is marked as completed' do
    user = User.create(email: "user@example.com", password: "12345678")
    order = Order.create(user_id: user.id, total: 100)
    PaymentMethod.create(name: "Paypal", code: "PEC")

    order.complete
    assert_equal order.state, "completed"
  end 

  # test 'products with stock zero cant be added to cart' do
  #   user = User.create(email: "user@example.com", password: "12345678")
  #   order = Order.create(user_id: user.id)
    
  #   product = Product.create(name: "test", price: 1, stock: 0, sku: "001")
  #   color = Color.create(name: "red")
  #   size = Size.create(name: "XL")

  #   variant = Variant.create(product_id: product.id, color_id: color.id, size_id: size.id, stock: 10)
    
  #   order.add_product(variant.id, 0)

  #   assert_equal order.order_items.count, 0
  # end

end
