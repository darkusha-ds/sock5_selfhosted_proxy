#!/usr/bin/env bash
set -euo pipefail

# Создаём пользователя для аутентификации внутри контейнера,
# чтобы Dante мог проверять credentials через системные аккаунты.
DANTE_USER="${DANTE_USER:-}"
DANTE_PASS="${DANTE_PASS:-}"

if [ -n "$DANTE_USER" ] && ! id "$DANTE_USER" &>/dev/null; then
  useradd -M -s /usr/sbin/nologin "$DANTE_USER"
  echo "${DANTE_USER}:${DANTE_PASS:-$(tr -dc 'A-Za-z0-9' </dev/urandom | head -c 16)}" | chpasswd
fi

# Лог в stderr, foreground-режим, чтобы Docker видел процесс
exec /usr/sbin/danted -f /etc/danted.conf