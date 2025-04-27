# ToDo Application

# 利用アーキテクチャ

- Node.js v20
- MySQL v8

# 利用方法

1. データベースの準備

    1. database を最初に準備

        名前は任意でOK。以下の例では `todo` で作成。

        ```
        CREATE DATABASE todo;
        ```

    1. 作成したデータベースにスキーマを作成

        `/data/MySQL/ddl.sql` を実行

    1. サンプルデータの投入

        `/data/MySQL/sampledata.sql` を実行

1. アプリの実行準備

    1. 環境変数ファイル `.env` を用意

        `.env` ファイルには以下の設定を行う

        ```
        MYSQL_HOST=<YOUR_HOST_NAME>
        MYSQL_USER=<USERNAME>
        MSYQL_PASSWORD=<PASSWORD>
        MYSQL_DATABASE=<DATABASE_NAME>
        ```

    1. パッケージのインストール

        ```
        npm install
        ```

1. アプリの実行

    ```
    npm start
    ```

## GitHub Actions へのシークレット設定

```
IMAGE_NAME
ACR_SERVER
ACR_USERNAME
ACR_PASSWORD
WEBAPP_NAME
WEBAPP_PUBLISH_PROFILE
```