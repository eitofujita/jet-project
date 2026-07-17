# 1. Hello Ruby

## 学習目標

Rubyプログラムの実行方法、値と変数、制御構造、メソッド、例外の基本を理解します。構文を覚えるだけでなく、式がどの値を返し、オブジェクトへどのメソッドを送っているかを説明できる状態を目指します。

## 実行方法

```bash
ruby --version
ruby hello.rb
irb
```

`ruby hello.rb`はファイルを上から評価します。`irb`は小さな式を試す対話環境です。プロジェクトがBundlerを使う場合、依存関係を固定するため`bundle exec ruby ...`や`bundle exec rails ...`を使います。

## 値、変数、式

Rubyでは数値、文字列、配列、クラスもオブジェクトです。変数は型付きの箱ではなく、オブジェクトへの参照を保持する名前です。

```ruby
user_name = "Mina"
post_count = 3
message = "#{user_name} has #{post_count} posts"
puts message
```

ローカル変数は`snake_case`、定数は`UPPER_CASE`、クラスは`CamelCase`が一般的です。文字列補間はダブルクォートで有効です。入力値は文字列なので、計算前に`Integer(value, exception: false)`などで妥当性を確認します。

## 条件分岐と真偽

Rubyで偽として扱われるのは`false`と`nil`だけです。`0`や空文字列も真です。

```ruby
age = 20

if age >= 18
  puts "adult"
else
  puts "minor"
end

status = age >= 18 ? "adult" : "minor"
```

`&&`は両方、`||`はいずれか、`!`は否定です。条件が複雑なら意味のある名前のメソッドへ分け、演算子の優先順位に依存しすぎないようにします。

## 繰り返し

Rubyでは`each`や`map`など、コレクションへ処理を依頼する書き方が中心です。

```ruby
likes = [3, 0, 8]
labels = likes.map { |count| "#{count} likes" }
popular = likes.select { |count| count >= 5 }
total = likes.sum
```

`each`は副作用を伴う反復、`map`は変換、`select`は条件に合う要素の抽出に使います。目的に合うメソッドを選ぶと、ループ変数の更新ミスを減らせます。

## メソッド

```ruby
def display_name(username, prefix: "@")
  raise ArgumentError, "username is required" if username.empty?

  "#{prefix}#{username}"
end

puts display_name("mina")
```

最後に評価した式が戻り値になりますが、途中で終了するときは`return`を使えます。引数の意味が分かりにくい場合はキーワード引数を使います。メソッドは一つの目的に絞り、名前から副作用の有無が想像できるようにします。

## 例外

例外は通常の分岐ではなく、処理を継続できない異常を伝えます。

```ruby
begin
  count = Integer(gets.chomp)
  puts 100 / count
rescue ArgumentError
  warn "整数を入力してください"
rescue ZeroDivisionError
  warn "0では割れません"
end
```

`rescue StandardError`ですべてを隠すと原因調査が難しくなります。回復可能な例外だけを狭く捕捉し、ログに文脈を残してください。

## Instagramクローンへの応用

投稿一覧の変換、コメント件数の集計、表示名生成などにコレクションとメソッドを使います。ただしRailsではデータベースの全行をRuby配列へ読み込むと遅くなるため、絞り込みや集計は可能な限りActive Recordへ任せます。

## 演習

1. ユーザー名と投稿数を受け取り、単数・複数を区別した文章を返すメソッドを作ってください。
2. Hashの配列から、公開済み投稿だけのタイトル一覧を作ってください。
3. 不正な投稿数に対して意味のある例外を発生させ、呼び出し側で処理してください。

## 確認チェックリスト

- RubyファイルとIRBを使い分けられる
- `nil`、`false`、空文字列の真偽を説明できる
- `each`、`map`、`select`の目的を区別できる
- 引数、戻り値、副作用を説明できる
- 捕捉する例外を狭くする理由を説明できる
