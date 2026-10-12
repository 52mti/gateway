#!/bin/sh
set -e

export JWT_SECRET="${JWT_SECRET:-dev-jwt-secret-change-me}"
export KONG_NORMAL_RATE_LIMIT_PER_MINUTE="${KONG_NORMAL_RATE_LIMIT_PER_MINUTE:-60}"
export UPSTREAM_URL="${UPSTREAM_URL:-http://host.docker.internal:18000}"
export KONG_REDIS_HOST="${KONG_REDIS_HOST:-redis}"
export KONG_REDIS_PORT="${KONG_REDIS_PORT:-6379}"

# Kong image does not include envsubst; substitute with sed.
sed \
  -e "s#\${JWT_SECRET}#${JWT_SECRET}#g" \
  -e "s#\${KONG_NORMAL_RATE_LIMIT_PER_MINUTE}#${KONG_NORMAL_RATE_LIMIT_PER_MINUTE}#g" \
  -e "s#\${UPSTREAM_URL}#${UPSTREAM_URL}#g" \
  -e "s#\${KONG_REDIS_HOST}#${KONG_REDIS_HOST}#g" \
  -e "s#\${KONG_REDIS_PORT}#${KONG_REDIS_PORT}#g" \
  /kong/kong.yml.template > /tmp/kong.yml

export KONG_DATABASE=off
export KONG_DECLARATIVE_CONFIG=/tmp/kong.yml
exec /docker-entrypoint.sh kong docker-start
