# README

# テーブル設計

## users テーブル

| Column                    | Type   | Option                    |
| ------------------------- | ------ | ------------------------- |
| nickname                  | string | null: false               |
| email                     | string | null: false, unique: true |
| encrypted_password        | string | null: false               |
| last_name                 | string | null: false               |
| first_name                | string | null: false               |
| last_name_kana            | string | null: false               |
| first_name_kana           | string | null: false               |
| birthday                  | date   | null: false               |


### Association

- has_many :items
- has_many :purchases

## items テーブル
 
| Column           | Type       | Option                         |
| ---------------- | ---------- | ------------------------------ |
| item_name        | string     | null: false                    |
| information      | text       | null: false                    |
| category_id      | integer    | null: false                    |
| sales_status_id  | integer    | null: false                    |
| shipping_cost_id | integer    | null: false                    |
| prefecture_id    | integer    | null: false                    |
| shipping_days_id | integer    | null: false                    |
| price            | integer    | null: false                    |
| user             | references | null: false, foreign_key: true |

### Association

- belongs_to :user
- has_one :buyer

## buyers テーブル

| Column     | Type       | Option                         |
| ---------- | ---------- | ------------------------------ |
| user       | references | null: false, foreign_key: true | 
| item       | references | null: false, foreign_key: true |

### Association

- belongs_to :user
- belongs_to :item
- has_one :address

## addresses テーブル

| Column        | Type       | Option                         |
| ------------- | ---------- | ------------------------------ |
| postal_code   | string     | null: false                    |
| prefecture_id | integer    | null: false                    |
| city          | string     | null: false                    |
| house_number  | string     | null: false                    |
| building      | string     |                                |
| telephone     | string     | null: false                    |
| buyer         | references | null: false, foreign_key: true | 

### Association

- belongs_to :buyer


