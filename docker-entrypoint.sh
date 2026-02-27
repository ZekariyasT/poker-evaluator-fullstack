#!/bin/sh
set -e

# Replace the placeholder baked into index.html with the real backend URL.
# BACKEND_URL is supplied via an environment variable (Kubernetes env / docker run -e).
BACKEND_URL="${BACKEND_URL:-http://localhost:8080}"

sed -i "s|BACKEND_URL_PLACEHOLDER|${BACKEND_URL}|g" \
    /usr/share/nginx/html/index.html

echo "Frontend configured: backend → ${BACKEND_URL}"

exec nginx -g 'daemon off;'
