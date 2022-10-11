class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.boolean :status
      t.belongs_to :shopper
      t.belongs_to :cart 
      t.belongs_to :address
      t.integer :retailer_id
      t.timestamps
    end
  end
end
