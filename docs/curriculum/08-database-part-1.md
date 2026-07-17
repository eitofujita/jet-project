# 8. Database Part 1

## 学習目標

リレーショナルデータベースの表、キー、制約、CRUDを理解し、アプリケーションのデータを重複や矛盾が生じにくい形に設計します。

## テーブルとキー

テーブルは同じ種類の事実を行として保持し、列が属性を定義します。主キーは行を一意に識別し、外部キーは別テーブルの行との関係を保証します。

```sql
CREATE TABLE posts (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  user_id BIGINT NOT NULL REFERENCES users(id),
  caption TEXT NOT NULL,
  created_at TIMESTAMP NOT NULL,
  updated_at TIMESTAMP NOT NULL
);
```

`NOT NULL`は値の欠落、外部キーは存在しないユーザーへの投稿を防ぎます。アプリケーションのvalidationは親切なエラー表示のために必要ですが、別プロセスや同時実行を含む最終的な整合性はデータベース制約でも守ります。

## CRUD

```sql
INSERT INTO posts (user_id, caption, created_at, updated_at)
VALUES (1, 'hello', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

SELECT id, caption FROM posts WHERE user_id = 1 ORDER BY created_at DESC;

UPDATE posts SET caption = 'updated', updated_at = CURRENT_TIMESTAMP WHERE id = 42;

DELETE FROM posts WHERE id = 42;
```

`UPDATE`や`DELETE`でWHEREを忘れると全行が対象になります。実行前に同じWHEREのSELECTで対象を確認し、本番操作ではトランザクションやバックアップ、レビュー手順を用意します。

## 関係の表現

- 1対多: UserとPost。postsに`user_id`
- 多対多: UserとPostのLike。likesに`user_id`と`post_id`
- 自己参照多対多: User同士のFollow。followsに`follower_id`と`followed_id`

```sql
CREATE UNIQUE INDEX index_likes_on_user_and_post
ON likes (user_id, post_id);
```

複合一意indexは同じユーザーの二重Likeを防ぎます。Followには自己フォローを禁止するCHECK制約も検討します。

## 正規化

正規化は一つの事実を一か所へ保存し、更新時の矛盾を減らす考え方です。投稿行へユーザー名を複製すると、ユーザー名変更時に過去投稿すべてを更新する必要があります。通常は`user_id`だけを保存してJOINで取得します。一方、監査記録の当時値や性能上の集計値など、目的が明確なら非正規化する場合もあります。その場合は更新方法と整合性の責任を設計します。

## データ型

ID、日時、真偽、文字列、長文、数値を意味に合う型で保存します。タイムゾーン付き日時、Unicode、文字列長、金額の精度を意識します。画像そのものをDBへ置くより、ストレージの識別情報とメタデータを管理することが一般的です。

## Instagramクローンへの応用

User、Post、Comment、Like、FollowのER図を先に描きます。削除時に関連行をどうするかは、単純なcascade、削除禁止、論理削除のどれが要件に合うか決めます。安易なcascadeは大量削除を引き起こし得ます。

## 演習と確認

1. 5テーブルの主キー、外部キー、NOT NULL、一意制約を設計してください。
2. ユーザーの投稿とコメントを取得するSQLを書いてください。
3. ユーザー名をpostsへ重複保存する問題を説明してください。

- 主キーと外部キーの違いを説明できる
- validationとDB制約を併用する理由を説明できる
- 1対多・多対多・自己参照を表現できる
- 安全なUPDATE/DELETEの手順を理解している
