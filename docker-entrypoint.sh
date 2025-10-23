#!/bin/bash
set -e

if ! id "$(id -u)" &>/dev/null; then
  echo "appuser:x:$(id -u):$(id -g):App User:/home:/bin/bash" >> /etc/passwd
fi

# Cria diretórios temporários com permissões corretas
mkdir -p /app/tmp/pids /app/tmp/cache /app/tmp/sockets /app/log
chmod -R 777 /app/tmp /app/log

# Cria arquivo de log se não existir
touch /app/log/development.log
chmod 666 /app/log/development.log

# Remove PID antigo
rm -f /app/tmp/pids/server.pid

chown -R "$(id -u):$(id -g)" /app/log /app/tmp

# Executa o comando passado
exec "$@"
