# 4. クラスとモジュール

## 学習目標

オブジェクトを状態と振る舞いのまとまりとして設計し、クラス・継承・モジュールを適切に使い分けます。単に機能するコードではなく、責務の境界と不変条件が明確なコードを目指します。

## クラスとカプセル化

```ruby
class Post
  attr_reader :author, :caption

  def initialize(author:, caption:)
    raise ArgumentError, "caption is too long" if caption.length > 2_200

    @author = author
    @caption = caption
    @published = false
  end

  def publish
    @published = true
  end

  def published?
    @published
  end
end
```

インスタンス変数を外部から自由に書き換えさせず、意味のあるメソッドを通して状態を変更すると、不正な状態を防げます。`attr_accessor`を無条件に付けるのではなく、読み取りと変更が本当に必要か判断します。`initialize`では生成直後から有効な状態になるよう必須値を受け取ります。

## クラスメソッドと値オブジェクト

クラスメソッドは個別インスタンスではなくクラス全体に関係する生成や検索に使います。一方、料金、期間、ユーザー名など独自ルールを持つ値は、StringやIntegerのまま散らすより小さな値オブジェクトにすると検証と比較を一か所へ集められます。

```ruby
class Username
  attr_reader :value

  def initialize(value)
    normalized = value.strip.downcase
    raise ArgumentError unless normalized.match?(/\A[a-z0-9_]+\z/)
    @value = normalized.freeze
  end
end
```

## 継承とコンポジション

継承は「種類である」という関係で、親の契約を子が守れる場合に使います。コード共有だけを目的に深い継承階層を作ると、親の変更が子へ予期せず波及します。「持っている」「協力する」という関係なら、別オブジェクトを受け取るコンポジションを優先します。

```ruby
class FeedBuilder
  def initialize(post_scope:)
    @post_scope = post_scope
  end

  def for(user)
    @post_scope.where(user_id: user.following_ids)
  end
end
```

## モジュール

モジュールは名前空間とMix-inに使えます。

```ruby
module Moderation
  class Result
    attr_reader :allowed, :reason
  end
end

module Publishable
  def publish
    @published = true
  end
end
```

Mix-inは複数クラスが本当に同じ振る舞いの契約を持つ場合に限定します。大量のメソッドや状態を注入すると依存が見えにくくなります。

## Instagramクローンへの応用

Active Recordモデルもクラスですが、永続化、検証、関連、業務ロジックを一つへ詰め込むと巨大になります。フィード構築、通知、画像審査のような複数モデルを調整する処理はサービスオブジェクトへ分離し、モデルには自身の整合性に関するルールを残します。

## 演習

1. `User`と`Post`を作り、投稿者以外はcaptionを変更できないメソッドを設計してください。
2. `LikeCounter`を依存として受け取る`PostPresenter`を作り、コンポジションを試してください。
3. 名前空間を使って管理者向け処理と一般利用者向け処理の同名クラスを分離してください。

## 確認チェックリスト

- クラスの責務と不変条件を説明できる
- 読み書き可能な属性を必要最小限にできる
- 継承とコンポジションを使い分けられる
- モジュールの名前空間とMix-inを区別できる
- Active Recordモデルへ処理を集中させる問題を理解している
