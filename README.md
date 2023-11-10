## users テーブル

| Column              | Type   | Options                    |
| ------------------- | ------ | -------------------------- |
| email               | string | null: false, unique: true  |
| encrypted_password  | string | null: false                |
| nickname            | string | null: false                |

  has_many :sleep_records
  has_many :sleep_statistics

## sleep_records テーブル

| Column      | Type       | Options                        |
| ----------- | ---------- | ------------------------------ |
| start_time  | datetime   |                                |
| set_time    | time       |                                |
| end_time    | time       |                                |
| quality     | string     | null: false                    |
| memo        | text       |                                |
| user        | references | null: false, foreign_key: true |

  belongs_to :user
