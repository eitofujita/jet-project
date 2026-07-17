# 5. RSpecによるテスト

## 学習目標

テストを仕様の実行可能な例として書き、正常系だけでなく境界値と失敗条件を検証します。失敗メッセージから「実装の不具合」「期待値の誤り」「準備の誤り」を切り分けられることを目指します。

## テストの役割

テストは不具合が存在しないことを証明しませんが、重要な振る舞いを繰り返し確認し、変更による退行を早く検出します。実装の内部手順ではなく、利用者から見える入力と結果を検証すると、リファクタリングで壊れにくくなります。

```ruby
RSpec.describe Username do
  describe "#value" do
    it "前後の空白を除き小文字へ正規化する" do
      username = described_class.new(" Mina_1 ")

      expect(username.value).to eq("mina_1")
    end

    it "許可されない文字を拒否する" do
      expect { described_class.new("mina!") }
        .to raise_error(ArgumentError)
    end
  end
end
```

`describe`は対象、`context`は条件、`it`は期待する振る舞いを表します。Arrange（準備）、Act（実行）、Assert（検証）を意識すると読みやすくなります。

## matcherと同一性

`eq`は値の等価性、`equal`は同一オブジェクトかを検証します。`change`は副作用、`raise_error`は例外、`include`は包含を確認します。期待値を広くしすぎると誤った結果も通るため、仕様に必要な具体性を持たせます。

```ruby
expect { post.publish }.to change(post, :published?).from(false).to(true)
expect(result).to include(post)
```

## let、subject、テストダブル

`let`は遅延評価され、参照された例でだけ作成されます。共通化しすぎると各テストの前提が見えなくなるため、重要な値は例内で明示して構いません。テストダブルは外部APIやメール送信の境界を隔離するために使い、自分が所有しないAPIを想像でmockしないようにします。

```ruby
notifier = instance_double("Notifier", deliver: true)
service = PublishPost.new(notifier: notifier)
service.call(post)
expect(notifier).to have_received(:deliver).with(post)
```

## テストケース設計

投稿本文が最大2,200文字なら、0、1、2,199、2,200、2,201文字を検討します。認可なら所有者、別ユーザー、未ログインを検証します。配列なら空、1件、複数件、重複、順序を検討します。バグ修正では、修正前に失敗する再現テストを追加してから実装します。

## Instagramクローンへの応用

ユーザー名の一意性、投稿本文の長さ、二重Like防止、フォローの自己参照禁止などをモデルレベルでテストします。HTTPや画面を含むテストは後の章で扱いますが、テストピラミッドを意識し、すべてを遅いブラウザテストへ寄せないようにします。

## よくある誤り

- 実装と同じ計算を期待値側でも行う
- 一つの例で多くの無関係な振る舞いを検証する
- 時刻、乱数、実行順序へ依存する
- privateメソッドだけを直接テストし、公開契約を検証しない
- テストを通すために仕様を弱める

## 演習

1. `Username`の空文字、境界長、無効文字、正規化をテストしてください。
2. Likeの追加と解除で件数が変化するテストを書いてください。
3. 失敗するテストを一つ作り、RSpecの差分とスタックトレースを説明してください。

## 確認チェックリスト

- テスト対象の公開契約を特定できる
- 正常系、異常系、境界値を設計できる
- `eq`と`equal`を区別できる
- テストダブルを境界に限定できる
- 失敗出力から原因を段階的に調査できる
