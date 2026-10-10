#!/bin/bash
# Docker の起動 → KH Coder の起動 → KH Coder 終了後に Docker を停止
cd "$(dirname "$0")" || exit 1

SERVICE=nl2e
MYSQL_PORT=13306
MYSQL_PASS=khcoder

# X11 接続を許可（失敗しても続行）
xhost +local:docker >/dev/null 2>&1 || true

# 終了時（正常終了・Ctrl+C 問わず）にコンテナを停止
trap 'echo "Docker コンテナを停止します..."; docker compose down' EXIT

docker compose up -d || exit 1

# MySQL の起動待ち（最大 120 秒）
echo "MySQL の起動を待っています..."
for _ in $(seq 1 60); do
    if docker compose exec -T $SERVICE mysqladmin --host 127.0.0.1 --port $MYSQL_PORT \
            -u root -p$MYSQL_PASS ping >/dev/null 2>&1; then
        break
    fi
    sleep 2
done

# 初回のみ khcoder データベース/ユーザーを作成
if ! docker compose exec -T $SERVICE mysql --host 127.0.0.1 --port $MYSQL_PORT \
        -u root -p$MYSQL_PASS -e 'use khcoder' >/dev/null 2>&1; then
    docker compose exec -T $SERVICE mysql --host 127.0.0.1 --port $MYSQL_PORT \
        -u root -p$MYSQL_PASS < mysql.txt
fi

# KH Coder の設定ファイルを配置
docker cp coder.ini $SERVICE:/KHCoder/khcoder/config/

# KH Coder 起動（終了するまでここで待機）
docker compose exec $SERVICE khcoder
