# テーブル設計


## users table

| Column             | Type   | Options     |
| ------------------ | ------ | ----------- |
| nickname           | string | null: false |
| email              | string | null: false, unique: true |
| encrypted_password | string | null: false |
| threads_count      | integer | default: 0 |
| comments_count     | integer | default: 0 |
| experience         | integer | default: 0 |

### Association

- has_many :threads
- has_many :messages, foreign_key: :sender_id
- has_many :comments
- has_many :rooms, through: :room_users
- has_many :room_users
- has_one :level

## threads table

| Column             | Type   | Options     |
| ------------------ | ------ | ----------- |
| title              | string | null: false |
| content            | text   | null: false |
| user_id            | bigint | null: false, foreign_key: true|

### Association

- belongs_to :user
- has_many :comments, dependent: :destroy

## comments table

| Column     | Type   | Options                       |
| ---------- | ------ | ----------------------------- |
| content    | text   | null: false                   |
| user_id    | bigint | null: false, foreign_key: true |
| thread_id  | bigint | null: false, foreign_key: true |

### Association

- belongs_to :thread,counter_cache: true
- belongs_to :user,counter_cache: true


## messages table

| Column  | Type       | Options                        |
| ------- | ---------- | ------------------------------ |
| content | text       |                                |
| sender_id  | bigint | null: false, foreign_key: { to_table: :users } |
| receiver_id| bigint | null: false, foreign_key: { to_table: :users } |
| room_id | bigint     | null: false, foreign_key: true |


### Association

- belongs_to :sender, class_name: 'User'
- belongs_to :receiver, class_name: 'User'
- belongs_to :room

## rooms table

| Column  | Type       | Options                        |
| ------- | ---------- | ------------------------------ |
| name    | string     |  null: false                   |
| is_group  | boolean  | default: false                 |

### Association

- has_many :users, through: :room_users
- has_many :messages
- has_many :room_users

## room_users table

| Column     | Type   | Options                        |
| ---------- | ------ | -----------------------------  |
| user_id    | bigint | null: false, foreign_key: true |
| room_id    | bigint | null: false, foreign_key: true |

### Association

- belongs_to :user
- belongs_to :room

## levels table

| Column  | Type       | Options                        |
| ------- | ---------- | ------------------------------ |
| level   | integer |  null:false,default:0          |
| user_id | bigint | null: false, foreign_key: true  |

### Association

- belongs_to :user