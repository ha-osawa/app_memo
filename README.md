# README
FBCのプラクティス「Sinatraを使ってWebアプリケーションの基本を理解する」の成果物として作成したメモアプリになります。

## 機能
- メモの一覧表示
- メモの追加
- メモの詳細
- メモの削除
- メモの編集

## 導入手順

### リポジトリのclone
任意の場所で以下を実行する。
```
git clone https://github.com/ha-osawa/app_memo.git
```
### gemのインストール
1. ターミナルで`cd path/to/app_memo`を実行しクローンしたリポジトリのディレクトリに移動する。
1. `bundle install`を実行する。

## アプリの起動
1. ターミナルで`ruby app.rb`を実行する。
1. Webブラウザを起動し、`http://localhost:4567`にアクセスする
 - ポート番号`4567`は`ruby app.rb`を実行した時に出る以下のような表示のportの部分を参照。
```
[2023-05-25 14:41:32] INFO  WEBrick 1.8.1
[2023-05-25 14:41:32] INFO  ruby 3.2.2 (2023-03-30) [x86_64-darwin21]
== Sinatra (v3.0.6) has taken the stage on 4567 for development with backup from WEBrick
[2023-05-25 14:41:32] INFO  WEBrick::HTTPServer#start: pid=31313 port=4567
```
