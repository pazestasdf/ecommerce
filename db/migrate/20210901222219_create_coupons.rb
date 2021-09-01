class CreateCoupons < ActiveRecord::Migration[5.2]
  def change
    create_table :coupons do |t|
      t.string :code # coupon code
      t.string :kind # massive or target user
      t.decimal :amount # amount or percentage
      t.string :discount # discount type: percent or fixed
      t.references :user, foreign_key: true
      t.integer :count

      t.timestamps
    end
  end
end
