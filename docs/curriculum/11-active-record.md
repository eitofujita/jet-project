# 11. Active Record

## 学習目標

Active RecordでテーブルとRubyオブジェクトを対応付け、migration、validation、association、scope、transactionを正しく使います。便利なAPIが生成するSQLとDB制約を意識できることを目指します。

## migration

```ruby
class CreateLikes < ActiveRecord::Migration[7.1]
  def change
    create_table :likes do |t|
      t.references :user, null: false, foreign_key: true
      t.references :post, null: false, foreign_key: true
      t.timestamps
    end

    add_index :likes, %i[user_id post_id], unique: true
  end
end
```

migrationはスキーマ変更の履歴です。適用済みmigrationを書き換えて環境差を作らず、新しいmigrationで変更します。大規模テーブルへの列追加、index作成、データ移行はロック時間を考慮し、スキーマ変更とデータのバックフィルを段階化します。

## モデルと関連

```ruby
class User < ApplicationRecord
  has_many :posts, dependent: :destroy
  has_many :likes, dependent: :destroy
end

class Post < ApplicationRecord
  belongs_to :user
  has_many :likes, dependent: :destroy

  validates :caption, length: { maximum: 2_200 }
end

class Like < ApplicationRecord
  belongs_to :user
  belongs_to :post
  validates :user_id, uniqueness: { scope: :post_id }
end
```

`dependent: :destroy`はcallbackを実行しながら関連を削除します。大量データでは遅くなり得るため、要件に応じてDB cascadeや削除制限を選びます。validationの一意性だけでは競合を防げないのでunique indexも必要です。

## CRUDと失敗

`save`は成功可否を返し、`save!`は失敗時に例外を発生させます。失敗を無視したくないサービス処理ではbang版が役立ちます。`update_all`、`delete_all`は高速ですがvalidationやcallbackを通らないため、意図と影響を理解して使います。

## queryとscope

```ruby
class Post < ApplicationRecord
  scope :recent, -> { order(created_at: :desc, id: :desc) }
  scope :published, -> { where(published: true) }
end

posts = Post.published.includes(:user, image_attachment: :blob).recent.limit(20)
```

Relationは遅延評価され、条件を連結できます。途中で`to_a`すると以降はRuby側処理になり得ます。SQLログを確認し、表示に必要な列・関連・件数だけを取得します。

## transactionとcallback

```ruby
ApplicationRecord.transaction do
  post.update!(published: true)
  AuditLog.create!(actor: user, action: "publish", target: post)
end
```

DB内の複数変更を一体化できますが、メールや外部APIはrollbackできません。外部処理はcommit後のjobへ渡し、再試行時の重複にも耐える設計にします。callbackへ大きな業務フローを隠すと実行順序が見えにくいため、明示的なサービスを検討します。

## Instagramクローンへの応用

Followは`follower`と`followed`をUserへ結ぶ自己参照associationです。自己フォロー禁止、組み合わせ一意性をモデルとDBで守ります。フィードはscopeとsubqueryを使い、N+1を避けます。

## 演習と確認

1. Followモデルの関連、validation、indexを設計してください。
2. 投稿、投稿者、Like件数を効率よく取得するqueryを検討してください。
3. callbackで通知する設計の問題と改善案を説明してください。

- migrationとschemaの関係を説明できる
- validationとDB制約を併用できる
- associationの削除方針を判断できる
- Relationの遅延評価とN+1を理解している
- transaction外の副作用を区別できる
