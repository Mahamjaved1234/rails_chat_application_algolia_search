class CreateCarts < ActiveRecord::Migration[7.0]
  def change
    create_table :carts do |t|
      t.decimal :total
      t.integer :qty
      t.belongs_to :shopper
      t.belongs_to :product
      t.jsonb :products
      t.timestamps
    end
  end
end
