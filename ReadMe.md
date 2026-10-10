# KH Coder in Docker

KH Coder を Docker 上で実行するための環境です。

本リポジトリは、[sinchiba-backyard/NL2E](https://github.com/sinchiba-backyard/NL2E) をフォークし、最近の Linux 環境や Docker Compose で利用しやすいように調整した。
- KH Coder を Docker で実行
- KH Coder 本体は Git Submodule で管理
- KH Coder 最新版へ追従可能
- MySQL を Docker コンテナで実行
- 不足していた Perl モジュールを Docker イメージへ組み込み済み
- コンテナ内での追加セットアップ不要

---

# 動作確認環境

- Ubuntu 22.04
- Bodhi Linux 7.0.0
- Docker Compose V2（Ubuntu 22.04 では `sudo apt install docker-compose-v2`）

---

# 初回セットアップ

## リポジトリ取得

```bash
git clone https://github.com/taoman26/NL2E.git
cd NL2E
```

## KH Coder の取得

KH Coder 本体は Git Submodule として管理されています。

```bash
git submodule update --init --recursive
```

## Docker イメージ作成

```bash
docker compose build
```

環境によっては作成に数十分かかる場合があります。

---

# KH Coder の更新

KH Coder 本体を最新版へ更新する場合は以下を実行してください。

```bash
git submodule update --recursive --remote
docker compose build
```

NL2E 自体に変更があった場合は、先にリポジトリを更新します。

```bash
git pull
git submodule update --recursive --remote
docker compose build
```

---

# チュートリアルデータの取得

KH Coder 公式チュートリアルを試す場合はデータをダウンロードします。

```bash
wget https://khcoder.net/tutorial_data_3x.zip
unzip tutorial_data_3x.zip -d KHCoder/khcoder/
```

---

# 起動

```bash
./do.sh
```

`do.sh` は以下を自動で行います。

1. X11 接続の許可（`xhost +local:docker`）
2. Docker コンテナの起動（`docker compose up -d`）
3. MySQL の起動待ちと、初回のみ `khcoder` データベースの作成
4. KH Coder の起動
5. KH Coder を閉じたら Docker コンテナを停止（`docker compose down`）

MySQL の接続設定は `coder.ini` で配置されるため、手動設定は不要です。

起動後は KH Coder のチュートリアルを試してみましょう。

- https://khcoder.net/tutorial.html

---

# ローカルのファイルを開く

ホストのホームディレクトリがコンテナ内の `/host` にマウントされます。
KH Coder のファイル選択ダイアログで `/host` 以下を開くと、ローカルのファイルを読み書きできます。

例: `~/data/sample.xlsx` → `/host/data/sample.xlsx`

別のディレクトリを使う場合は、環境変数 `NL2E_DATA_DIR` を指定して起動します。

```bash
NL2E_DATA_DIR=/path/to/data ./do.sh
```

注意: コンテナは root で動作するため、KH Coder がマウント先に作成したファイルの所有者は root になります。

---

# 手動で操作する場合

`do.sh` を使わず個別に操作することもできます。

```bash
xhost +local:docker
docker compose up -d
docker exec -it nl2e /bin/bash
khcoder
exit
docker compose down
```

状態確認は `docker compose ps` で行えます。

---

# Docker Compose の補足

本環境では GUI アプリケーション表示のために Host Network を使用しています。

```yaml
network_mode: host
```

Linux 環境を前提としています。

---

# トラブルシューティング

## 「Can't locate File/Copy/Recursive.pm」

古い Docker イメージを利用している可能性があります。

以下を実行してください。

```bash
docker compose build --no-cache
```

---

## 「Can't open display」

X11 接続が許可されていない可能性があります。

```bash
xhost +local:docker
```

を実行した後に再度起動してください。

---

## MySQL に接続できない

コンテナの起動状態を確認してください。

```bash
docker compose ps
```

ログ確認

```bash
docker compose logs mysql
```

---

# macOS

macOS を利用する場合は XQuartz が必要です。

## XQuartz インストール

- https://www.xquartz.org/

## XQuartz 設定

「環境設定」→「セキュリティ」

- 「接続を認証」のチェックを外す
- 「ネットワーク・クライアントからの接続を許可」を有効化

設定後に XQuartz を再起動してください。

## docker-compose.yml 修正

```yaml
DISPLAY: ${DISPLAY}
```

を

```yaml
DISPLAY: host.docker.internal:0
```

へ変更します。

---

# コンテナ名について

Docker Compose V2 ではコンテナ名の命名規則が変更されています。

例えば

```text
nl2e_nl2e_1
```

が

```text
nl2e-nl2e-1
```

になる場合があります。

本フォーク版では `container_name: nl2e` を使用しているため、以下のコマンドを利用できます。

```bash
docker exec -it nl2e /bin/bash
```

---

# スクリーンショット

![KH Coder](khcoder.png)

---

# 謝辞

本リポジトリは以下の成果物を利用しています。

- KH Coder  
  https://khcoder.net/

- 原版 NL2E  
  https://github.com/sinchiba-backyard/NL2E
