class Variant < ApplicationRecord
  belongs_to :product
  belongs_to :color
  belongs_to :size

  # variante unica
  validates :product_id, uniqueness: { scope: %i[color_id size_id] }
end
