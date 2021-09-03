class Payment < ApplicationRecord
  belongs_to :order
  belongs_to :payment_method

  def close!
    ActiveRecord::Base.transaction do
      complete
      order.complete
    end
  end

  def complete
    # self.state = "completed"
    update_attribute(:state, "completed")
  end
end
