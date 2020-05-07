# README


## usersテーブル
|Column      |Type    |Options                                     |
|------------|--------|--------------------------------------------|
|name        |string  |null: false,                     |
|name_kana   |string  |null: false,                     |
|email       |string  |null: false, unique: true                 |
|gender      |integer |                   |
|birth_day   |date    |null: false,                  |
|password    |string  |null: false,               |


### Association
  has_one :credit_card
  has_one :profile
  has_one :address
  has_many :purchased_infos
  has_many :items
  has_many :comments
  


## addressテーブル
|Column         |Type      |Options                                    |
|---------------|--------|-------------------------------------------|
|post_code      |integer |null: false                                           |
|city           |string  |null: false                                           |
|block          |string  |null: false                                           |
|building       |string  |null: false                                           |
|user_id        |integer |null: false, foreign_key: true             |
|prefectures_id |integer |null: false, foreign_key: true             |

### Association
  belongs_to :user
  belongs_to_active_hash :prefecture
  


### profilesテーブル
|Column|Type|Options|
|------|----|-------|
|user_id|integer|null: false, foreign_key: true|
|nickname|string|null: false|
|image|string||
|profile|text||

Association
belongs_to :user

### credit_cardsテーブル
|Column|Type|Options|
|------|----|-------|
|user_id|intger|null: false, foreign_key: true|
|customer_id|string|null: false|
|card_id|string|null: false|

Association
belongs_to :user

### commentsテーブル
|Column|Type|Options|
|------|----|-------|
|user_id|intger|null: false, foreign_key: true|
|item_id|intger|null: false, foreign_key: true|
|comment|text|null: false    |

Association
belongs_to :user
belongs_to :item

### imagesテーブル
|Column|Type|Options|
|------|----|-------|
|image|string|null: false|
|item_id|integer|null: false, foreign_key: true|

Association
belongs_to :item

### categoriesテーブル
|Column|Type|Options|
|------|----|-------|
|name|string|null: false|
|ancestry|string|      |

Association
has_many :items
has_ancestry

### brandsテーブル
|Column|Type|Options|
|------|----|-------|
|name|string|null: false|

Association
has_many :items

### purchased_infosテーブル
|Column|Type|Options|
|------|----|-------|
|user_id|integer|null: false, foreign_key: true|
|item_id|integer|null: false, foreign_key: true|
|purchase_date|date|null: false|

Association
belongs_to :item
belongs_to :user

### itemsテーブル
|Column|Type|Options|
|------|----|-------|
|name|string|null: false|
|description|text|null: false|
|price|integer|null: false|
|size|integer|         |
|category_id|integer|null: false, foreign_key: true|
|brand_id|integer| foreign_key: true|
|condition|string|null: false|
|shipping_fee|integer|null: false|
|shipping_fee_side|boolean|null: false|
|prefectures_id|integer|null: false, foreign_key: true|
|shipping_days|integer||
|user_id|integer|foreign_key: true|

### Association
- belongs_to :user
- belongs_to_active_hash :prefecture
- belongs_to :brand
- belongs_to :category
- belongs_to :purchased_info
- has_many :images
- has_many :comments

