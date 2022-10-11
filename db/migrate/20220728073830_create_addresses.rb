class CreateAddresses < ActiveRecord::Migration[7.0]
  def change
    create_table :addresses do |t|
      t.text :detail
      t.string :name

      t.timestamps
      t.belongs_to :shopper 
    end
  end
end
