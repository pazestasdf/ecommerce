class Order < ApplicationRecord
  before_create -> { generate_number(hash_size) }

  belongs_to :user

  has_many :order_items
  has_many :products, through: :order_items
  has_many :payments

  validates :number, uniqueness: true

  def generate_number(size)
    self.number ||= loop do
      random = random_candidate(size)
      break random unless self.class.exists?(number: random)
    end
  end

  def totalInCents
    total * 100
  end

  def complete
    update_attribute(:state, "completed")
  end
  
  def create_payment(pm, tkn)
    # payment_method = PaymentMethod.find_by(code: "PEC")
    Payment.create(
      order_id: self.id,
      payment_method_id: PaymentMethod.find_by(code: pm).id,
      state: "processing",
      total: self.total,
      token: tkn
    )
  end

  def random_candidate(size)
    "#{hash_prefix}#{Array.new(size){rand(size)}.join}"
  end

  def hash_prefix
    "BO"
  end

  def hash_size
    9
  end
  
  def add_product(variant_id, quantity)
    variant = Variant.find(variant_id)
    if variant && (variant.stock > 0)
      order_items.create(variant_id: variant.id, quantity: quantity, price: variant.product.price)
      compute_total
    end
  end

  def compute_total
    sum = 0
    order_items.each do |item|
      sum += item.price
    end
    update_attribute(:total, sum)
  end
end
