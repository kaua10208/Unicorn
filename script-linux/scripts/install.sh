#!/bin/bash

CONFIG="config/apps.json"
DOWNLOAD_DIR="temp/apks"

mkdir -p "$DOWNLOAD_DIR"

# 🔹 Detectar arquitetura
ABI=$(adb shell getprop ro.product.cpu.abi)

if [[ "$ABI" == *"arm64"* ]]; then
    ARCH="arm64"
else
    ARCH="armv7"
fi

echo "Arquitetura detectada: $ARCH"
echo "----------------------"

# 🔹 Filtro opcional (ex: chromite, libretube)
FILTER=$1

# 🔹 Contar apps
if [ -n "$FILTER" ]; then
    TOTAL=1
else
    TOTAL=$(jq '.apps | length' "$CONFIG")
fi

COUNT=1

echo "Baixando aplicativos..."
echo "----------------------"

jq -c '.apps[]' "$CONFIG" | while read app; do

    id=$(echo "$app" | jq -r '.id')
    name=$(echo "$app" | jq -r '.name')
    url=$(echo "$app" | jq -r '.url // empty')
    arm64=$(echo "$app" | jq -r '.arm64 // empty')
    armv7=$(echo "$app" | jq -r '.armv7 // empty')

    # 🔹 Proteção contra JSON quebrado
    if [[ -z "$id" || ( -z "$url" && -z "$arm64" && -z "$armv7" ) ]]; then
        echo "Pulando app inválido..."
        continue
    fi

    # 🔹 Filtro
    if [[ -n "$FILTER" && "$FILTER" != "$id" ]]; then
        continue
    fi

    # 🔹 Escolher URL
    if [ "$ARCH" = "arm64" ] && [ -n "$arm64" ]; then
        DOWNLOAD_URL="$arm64"
    elif [ "$ARCH" = "armv7" ] && [ -n "$armv7" ]; then
        DOWNLOAD_URL="$armv7"
    else
        DOWNLOAD_URL="$url"
    fi

    echo "Baixando $name [$COUNT/$TOTAL]"

    wget -q --show-progress -O "$DOWNLOAD_DIR/$id.apk" "$DOWNLOAD_URL"

    COUNT=$((COUNT+1))

done

echo "----------------------"
echo "Instalando aplicativos..."
echo "----------------------"

COUNT=1

for apk in "$DOWNLOAD_DIR"/*.apk; do

    name=$(basename "$apk" .apk)

    echo "Instalando $name [$COUNT/$TOTAL]"

    adb install -r "$apk" > /dev/null 2>&1

    COUNT=$((COUNT+1))

done

echo "Limpando..."
rm -rf "$DOWNLOAD_DIR"

echo "Concluído 🚀"