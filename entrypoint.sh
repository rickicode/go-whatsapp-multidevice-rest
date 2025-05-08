#!/bin/bash

echo "Generating .env from environment variables..."

# Atur prefix yang akan dimasukkan
PREFIXES=("SERVER_" "HTTP_" "AUTH_" "WHATSAPP_" "LIBWEBP_")

# Buat file .env baru
echo "# Auto-generated .env file" > .env

# Loop semua env var yang ada
env | while IFS='=' read -r key value; do
  for prefix in "${PREFIXES[@]}"; do
    if [[ "$key" == "$prefix"* ]]; then
      echo "$key=$value" >> .env
      break
    fi
  done
done

echo "Generated .env:"
cat .env
echo "Starting app..."
exec ./main
