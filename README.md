# テーブル設計

## users テーブル

| Column              | Type       | Options                        |
| ------------------- | ---------- | ------------------------------ |
| nickname            | string     | null: false, unique: true      |
| email               | string     | null: false, unique: true      |
| encrypted_password  | string     | null: false                    |
| last_name           | string     | null: false                    |
| first_name          | string     | null: false                    |
| last_name_kana      | string     | null: false                    |
| first_name_kana     | string     | null: false                    |
| birth_date          | date       | null: false                    |
| item_id             | references | null: false, foreign_key: true |
| purchase_record_id  | references | null: false, foreign_key: true |

### Association

- has_many :items
- has_many :purchase_records


## items テーブル

| Column                   | Type       | Options                        |
| ------------------------ | ---------- | ------------------------------ |
| item_name                | string     | null: false                    |
| item_info                | text       | null: false                    |
| item_category            | string     | null: false                    |
| item_sales_status        | string     | null: false                    |
| item_shipping_fee_status | string     | null: false                    |
| item_prefecture          | string     | null: false                    |
| item_scheduled_delivery  | string     | null: false                    |
| item_price               | integer    | null: false                    |
| user_id                  | references | null: false, foreign_key: true |
| purchase_record_id       | references | null: false, foreign_key: true |

### Association

- belongs_to :user
- has_one :purchase_record


## purchase_records テーブル

| Column              | Type       | Options                        |
| ------------------- | ---------- | ------------------------------ |
| item_id             | references | null: false, foreign_key: true |
| user_id             | references | null: false, foreign_key: true |
| shipping_address_id | references | null: false, foreign_key: true |

### Association

- belongs_to :user
- belongs_to :item
- belongs_to :shipping_address


## shipping_addresses テーブル

| Column       | Type       | Options                        |
| ------------ | ---------- | ------------------------------ |
| postal_code  | integer    | null: false                    |
| prefecture   | string     | null: false                    |
| city         | string     | null: false                    |
| addresses    | text       | null: false                    |
| building     | text       | null: true                     |
| phone_number | integer    | null: false                    |

### Association

- belongs_to :purchase_record


