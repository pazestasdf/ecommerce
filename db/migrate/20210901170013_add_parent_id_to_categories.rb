class AddParentIdToCategories < ActiveRecord::Migration[5.2]
  def change
    add_reference :categories, :category, foreign_key: true
  end
end
