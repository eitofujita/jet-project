# 13. 認可と実装演習

## 学習目標

「誰であるか」を確認する認証と、「何をしてよいか」を判断する認可を分離します。画面上のボタン非表示だけに頼らず、すべての保護対象操作をサーバー側で検証します。

## 所有権による認可

危険な取得方法は、全投稿からIDだけで検索して更新することです。

```ruby
# 悪い例: ログインしていれば他人の投稿も取得できる
@post = Post.find(params[:id])
@post.update!(post_params)
```

所有者だけが編集できるなら、認可済みscopeから取得します。

```ruby
def set_owned_post
  @post = current_user.posts.find(params[:id])
end
```

この方法は他人の投稿を404にでき、存在自体を隠せます。要件として403を返すなら、対象取得後に明示的なpolicy判定を行います。どちらを採用するか統一してください。

## Policyによる分離

権限が所有者、管理者、公開状態など複数条件になる場合は、Policyへ判断を集約します。

```ruby
class PostPolicy
  def initialize(user, post)
    @user = user
    @post = post
  end

  def update?
    @user.admin? || @post.user_id == @user.id
  end

  def destroy?
    update?
  end
end
```

Policyはboolean判断に集中させ、保存の副作用を持たせません。一覧では個別行を取得してから除外するのではなく、Policy Scopeで閲覧可能なRelationを作ります。

## 水平・垂直権限昇格

水平権限昇格は、一般ユーザーが別ユーザーの同種リソースへアクセスする問題です。`/posts/42/edit`のID変更で検証します。垂直権限昇格は、一般ユーザーが管理者機能を実行する問題です。URLを隠すだけでは防げないため、actionごとにサーバーで確認します。

## Instagramクローンへの応用

コメント、Like、Followは、投稿の所有権とは異なる認可条件を持ちます。機能名だけで一括判断せず、対象リソース、操作、現在のユーザーの関係を明示します。

- Comment削除: コメント作成者または管理者だけ
- Like作成: 認証済みユーザー。対象投稿の閲覧権限も必要
- Follow作成: 自分をfollowerに固定し、対象だけを入力から受け取る
- 非公開アカウント: フォロー承認状態を閲覧scopeへ反映

複数IDを受ける操作では、それぞれがcurrent userの権限範囲にあるか確認します。

## TOCTOUとDB整合性

認可確認後、保存までに対象状態が変わる可能性があります。重要な状態遷移ではtransactionとlockを検討します。ただし認可と一意性は別問題であり、二重Like防止にはDB制約が必要です。

## 実装手順

1. 誰が、どのリソースへ、どの操作を行えるか権限表を作る。
2. Controllerの全actionと非同期job・APIを列挙する。
3. scopeと個別Policyを実装する。
4. 所有者、別ユーザー、未認証、管理者をテストする。
5. UIでは許可されない操作を隠すが、サーバー検証は残す。

## 演習と確認

1. Post、Comment、Like、Followの権限表を作ってください。
2. URLのIDを書き換えるrequest specを作り、他人の投稿が更新されないことを検証してください。
3. 非公開投稿をフィードscopeから除外してください。

- 認証と認可を具体例で区別できる
- 取得scopeで水平権限昇格を防げる
- PolicyとPolicy Scopeの責務を説明できる
- UI非表示だけでは不十分と理解している
- 全actionとバックグラウンド処理を認可対象として確認できる
