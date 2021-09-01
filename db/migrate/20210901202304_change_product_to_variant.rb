class ChangeProductToVariant < ActiveRecord::Migration[5.2]
  def change
    rename_column :order_items, :product_id, :variant_id
  end
end
