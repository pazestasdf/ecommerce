require 'test_helper'

class PaymentTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end


  test 'order is marked as completed' do
    user = User.create(email: "user@example.com", password: "12345678")
    order = Order.create(user_id: user.id, total: 100)
    pm = PaymentMethod.create(name: "Paypal", code: "PEC")
    
    payment = Payment.create(order_id: order.id, payment_method_id: pm.id, state: "processing")

    payment.complete

    assert_equal payment.state, "completed"
  end 

  test "payment close" do
    user = User.create(email: "user@example.com", password: "12345678")
    order = Order.create(user_id: user.id, total: 100)
    pm = PaymentMethod.create(name: "Paypal", code: "PEC")
    
    payment = Payment.create(order_id: order.id, payment_method_id: pm.id, state: "processing")
    payment.close!

    assert_equal payment.state, "completed"
    assert_equal payment.order.state, "completed"

  end
end
