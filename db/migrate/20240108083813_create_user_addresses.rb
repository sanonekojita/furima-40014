class CreateUserAddresses < ActiveRecord::Migration[7.0]
  def change
    create_table :user_addresses do |t|
      t.string     :user_postal_code,     null: false
      t.integer    :user_prefecture_id,   null: false
      t.string     :user_city,            null: false
      t.text       :user_addresses,       null: false
      t.text       :user_building,        null: true
      t.string     :user_phone_number,    null: false
      t.references :user,                 null: false, foreign_key: true
      t.timestamps
    end
  end
end
