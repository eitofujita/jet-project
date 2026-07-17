# 3. ファイル操作

## 学習目標

パスと文字コードを意識してファイルを安全に読み書きし、CSV・JSONの構造化データを扱えるようにします。ファイルが存在しない、権限がない、内容が壊れている場合にも、原因を隠さず処理できることを目指します。

## パスとリソース管理

相対パスは実行時のカレントディレクトリを基準にするため、起動場所が変わると失敗します。プログラムのファイル位置を基準にする場合は`__dir__`と`File.join`を使います。

```ruby
path = File.join(__dir__, "data", "posts.txt")

File.open(path, "r:utf-8") do |file|
  file.each_line.with_index(1) do |line, number|
    puts "#{number}: #{line.chomp}"
  end
end
```

ブロック形式の`File.open`は処理後や例外発生時にも自動で閉じます。大きなファイルを`File.read`で一括読込するとメモリを消費するため、`each_line`で逐次処理します。

## 書き込み

```ruby
output = File.join(__dir__, "tmp", "report.txt")
FileUtils.mkdir_p(File.dirname(output))

File.open(output, "w:utf-8") do |file|
  file.puts "post_id,like_count"
  file.puts "1,12"
end
```

`w`は既存内容を切り捨て、`a`は末尾へ追記します。重要なファイルを更新する場合は、一時ファイルへ完全に書き込んでからrenameする方法を使うと、途中終了による半端な内容を避けられます。外部入力をそのままパスへ連結すると、`../`によるディレクトリ逸脱が起きるため禁止します。

## CSVとJSON

```ruby
require "csv"
require "json"

CSV.foreach("posts.csv", headers: true) do |row|
  puts row["caption"]
end

payload = JSON.parse(File.read("post.json"), symbolize_names: true)
puts payload[:caption]
```

CSVはカンマや改行を引用できるため、`split(",")`で解析してはいけません。JSONのパース結果は信頼済みとは限りません。必須キー、型、長さを別途検証します。秘密情報を含むデータをログやリポジトリへ保存しないでください。

## 例外処理

```ruby
begin
  data = JSON.parse(File.read(path))
rescue Errno::ENOENT
  warn "ファイルが見つかりません: #{path}"
rescue JSON::ParserError => error
  warn "JSON形式が不正です: #{error.message}"
end
```

存在しないことを「空データ」と同じ扱いにすると障害を見逃します。回復方法が異なる例外を分け、必要な文脈を残します。ただし、パスに個人情報や秘密が含まれる場合はログ出力を制限します。

## Instagramクローンへの応用

アップロード画像をローカルファイルへ直接保存する設計は、複数サーバーやデプロイで失われる可能性があります。RailsのActive Storageを介してストレージを抽象化し、ファイルの種類・サイズを検証します。CSVエクスポートでは大量データを分割取得し、権限のある利用者だけがダウンロードできるようにします。

## 演習

1. JSON形式の投稿一覧を読み、必須項目を検証してCSVへ出力してください。
2. 壊れたJSON、存在しないファイル、UTF-8でないファイルを用意し、エラーの違いを確認してください。
3. 一時ファイルとrenameを使う安全な設定ファイル更新を実装してください。

## 確認チェックリスト

- 相対パスの基準を説明できる
- ブロック形式でファイルを確実に閉じられる
- 大容量ファイルを逐次処理できる
- CSV/JSON専用ライブラリを使う理由を説明できる
- パストラバーサルとアップロード検証の必要性を理解している
