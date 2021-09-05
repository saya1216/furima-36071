# README

# テーブル設計

## users テーブル

| Column          | Type   | Option      |
| --------------- | ------ | ----------- |
| nickname        | string | null: false |
| email           | string | null: false |
| password        | string | null: false |
| last_name       | string | null: false |
| first_name      | string | null: false |
| last_name_kana  | string | null: false |
| first_name_kana | string | null: false |
| birthday        | date   | null: false |


### Association

- has_many :items
- has_many :purchases

## items テーブル
 
| Column              | Type       | Option                         |
| ------------------- | -----------| ------------------------------ |
| item_name           | string     | null: false                    |
| information         | text       | null: false                    |
| category            | string     | null: false                    |
| sales_status        | string     | null: false                    |
| shipping_cost       | string     | null: false                    |
| shipping_prefecture | string     | null: false                    |
| shipping_days       | string     | null: false                    |
| price               | string     | null: false                    |
| user                | references | null: false, foreign_key: true |

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

| Column      | Type       | Option                         |
| ----------- | ---------- | ------------------------------ |
| postal_code | string     | null: false                    |
| prefecture  | string     | null: false                    |
| city        | string     | null: false                    |
| address     | string     | null: false                    |
| building    | string     |                                |
| telephone   | string     | null: false                    |
| buyer       | references | null: false, foreign_key: true | 

### Association

- belongs_to :buyer


This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
