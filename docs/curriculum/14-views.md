# 14. View

## 学習目標

ERB、layout、partial、form helperを使って、保守しやすく安全なHTMLを生成します。表示ロジックと業務ロジックを分離し、XSS、アクセシビリティ、エラー表示を考慮できることを目指します。

## ERBと自動エスケープ

```erb
<h1><%= @post.user.username %>の投稿</h1>
<p><%= @post.caption %></p>
```

`<% ... %>`はRubyを実行し、`<%= ... %>`は結果を出力します。Railsは通常HTMLをエスケープし、投稿本文に`<script>`があってもコードとして実行されないようにします。外部入力へ安易に`html_safe`や`raw`を使うとXSSになります。装飾を許可する場合は、許可タグを限定したsanitizationを行います。

## layout、partial、helper

layoutはページ全体の共通枠、partialは投稿カードやフォームの再利用単位です。

```erb
<%= render partial: "posts/post", collection: @posts, as: :post %>
```

partialが多数の暗黙なインスタンス変数へ依存すると再利用しにくいため、localsを明示します。日付や表示名など小さな表現変換はhelperやpresenterへ置き、DB更新や複雑なqueryをViewから実行しません。

## フォームと検証エラー

```erb
<%= form_with model: post do |form| %>
  <% if post.errors.any? %>
    <div role="alert">
      <h2>入力内容を確認してください</h2>
      <ul>
        <% post.errors.full_messages.each do |message| %>
          <li><%= message %></li>
        <% end %>
      </ul>
    </div>
  <% end %>

  <%= form.label :caption %>
  <%= form.text_area :caption, required: true %>
  <%= form.label :image %>
  <%= form.file_field :image, accept: "image/png,image/jpeg" %>
  <%= form.submit %>
<% end %>
```

ブラウザ側validationは利便性のためで、攻撃者は迂回できます。サーバー側validationを必ず残します。labelを入力へ関連付け、キーボード操作、focus、色以外のエラー表現、画像の代替テキストを確認します。

## Turbo

Turbo Driveはページ遷移を高速化し、Turbo Frames/Streamsは部分更新を可能にします。ただし通常のHTMLリクエストでも正しいレスポンスになる設計を土台にします。成功・失敗status、frame ID、redirectの違いを理解し、JavaScriptで無理にDOMを同期しないようにします。

## 性能

Viewで`post.user`や`post.likes.count`を反復するとN+1が起きます。Controllerまたはquery objectで必要な関連・集計を取得します。巨大画像はvariantを生成し、幅・高さを指定してレイアウトずれを抑え、lazy loadingも検討します。

## Instagramクローンへの応用

投稿カードをpartial化し、投稿者、画像、caption、Like数、コメントを表示します。編集・削除ボタンはPolicy結果に応じて表示しますが、Controllerの認可は削除しません。Like操作はTurbo Streamで件数とボタンを更新しても、DBの一意制約を維持します。

## 演習と確認

1. 投稿フォームをpartial化し、新規作成と編集で共有してください。
2. XSS文字列を投稿し、自動エスケープを確認してください。
3. キーボードだけで登録から投稿まで操作し、問題を記録してください。

- ERBの実行タグと出力タグを区別できる
- 自動エスケープを無効化する危険を説明できる
- partialの依存をlocalsで明示できる
- server-side validationを維持できる
- View起因のN+1とアクセシビリティを確認できる
