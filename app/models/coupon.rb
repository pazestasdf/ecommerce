class Coupon < ApplicationRecord
  belongs_to :user, optional: true

  def self.usable?
    valid_on_count?
  end

  def self.valid_on_count?
    if kind.eql?('target')
      return(count>0)
    end
    return true
  end

  def compute_total(total)
    if discount.eql?('percent')
      return total * (amount/100)
    else
      total = total - amount
      (total < 0) ? 0 : total
    end
  end

end
