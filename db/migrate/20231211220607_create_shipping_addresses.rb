class CreateShippingAddresses < ActiveRecord::Migration[7.0]
  def change
    create_table :shipping_addresses do |t|
      t.string     :postal_code,     null: false
      t.integer    :prefecture_id,   null: false
      t.string     :city,            null: false
      t.text       :addresses,       null: false
      t.text       :building,        null: true
      t.string     :phone_number,    null: false
      t.references :purchase_record, null: false, foreign_key: true
      t.timestamps
    end
  end
end
