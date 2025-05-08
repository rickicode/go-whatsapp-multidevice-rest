#!/bin/bash

echo "Generating .env from all environment variables..."

# Buat file baru
echo "# Auto-generated .env file" > .env

# Ambil semua environment variable yang aktif di container
printenv | while IFS='=' read -r key value; do
  # Hindari variable internal dari shell & Docker
  if [[ "$key" != "_" && "$key" != "PWD" && "$key" != "HOME" && "$key" != "PATH" && "$key" != "SHLVL" ]]; then
    echo "$key=$value" >> .env
  fi
done

echo ".env file created with contents:"
cat .env

# Jalankan aplikasi
exec ./main
