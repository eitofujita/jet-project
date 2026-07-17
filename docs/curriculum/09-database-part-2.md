# 9. Database Part 2

## 学習目標

JOIN、index、transaction、実行計画を理解し、正しさと性能を両立する問い合わせを設計します。N+1を検出し、同時実行時の競合を考慮できることを目指します。

## JOINと集計

```sql
SELECT posts.id, posts.caption, users.username, COUNT(likes.id) AS like_count
FROM posts
JOIN users ON users.id = posts.user_id
LEFT JOIN likes ON likes.post_id = posts.id
GROUP BY posts.id, users.username
ORDER BY posts.created_at DESC;
```

`INNER JOIN`は対応行があるものだけ、`LEFT JOIN`は左側を必ず残します。Likeが0件の投稿も表示するにはLEFT JOINが必要です。JOIN後は行が増えるため、COUNT対象や重複を理解せず`DISTINCT`で隠さないでください。

## index

indexは検索を速くする補助構造ですが、保存容量とINSERT/UPDATE/DELETEの更新コストが増えます。WHERE、JOIN、ORDER BYで頻繁に使う列を、実際の問い合わせに合わせて選びます。

```sql
CREATE INDEX index_posts_on_user_id_and_created_at
ON posts (user_id, created_at DESC);
```

複合indexは列順が重要です。低選択性のboolean列だけのindexは効果が小さい場合があります。推測で増やさず、`EXPLAIN`または`EXPLAIN ANALYZE`で実行計画と実測を確認します。

## transactionと同時実行

transactionは複数操作を一つの単位としてcommitまたはrollbackします。

```sql
BEGIN;
INSERT INTO likes (user_id, post_id) VALUES (7, 42);
UPDATE post_statistics SET like_count = like_count + 1 WHERE post_id = 42;
COMMIT;
```

ただしtransactionを使うだけで競合が消えるわけではありません。二つの処理が同時に存在確認してからINSERTすると重複し得るため、一意制約を置き、制約違反を適切に処理します。必要に応じて行ロック、楽観的ロック、分離レベルを検討します。外部API呼び出しを長いtransaction内で行うとロック時間が延びます。

## N+1問題

投稿を1回で取得した後、各投稿のユーザーを個別に取得すると、投稿数Nに応じて追加クエリが発生します。Railsでは`includes(:user)`などで先読みします。ただし常に先読みするとメモリ消費が増えるため、画面で必要な関連だけを対象にします。

## ページネーション

大量の投稿を一度に返しません。OFFSET方式は簡単ですが、深いページで遅くなり、更新中の重複・欠落が起き得ます。フィードでは`created_at`と`id`を使うカーソル方式を検討し、同時刻でも順序が一意になるようにします。

## Instagramクローンへの応用

フィードはフォロー先の投稿を新しい順に取得し、投稿者と画像、Like件数を必要な範囲で先読みします。巨大な`following_ids`配列をRubyへ読み込むのではなく、subqueryやJOINを使います。性能対策前に、期待件数とSQL、実行計画を観測します。

## 演習と確認

1. Likeが0件の投稿も含む集計SQLを書いてください。
2. フィード検索に適したindex候補を作り、列順の理由を説明してください。
3. 二重Likeが同時発生する流れと、制約による防止方法を書いてください。

- INNER JOINとLEFT JOINを使い分けられる
- indexの利益とコストを説明できる
- transactionと一意制約の役割を区別できる
- N+1をログから特定できる
- ページネーション方式の違いを説明できる
