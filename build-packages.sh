#!/bin/bash

set -e

OUTPUT_DIR="dist"
PACKAGE_NAME="zt-firewall-suite"
VERSION="1.0.0"

mkdir -p "$OUTPUT_DIR"
rm -rf pkg-root || true
mkdir -p pkg-root/usr/local/bin

cp install-suite.sh pkg-root/usr/local/bin/
cp -r modules pkg-root/opt/zt-firewall-suite/

echo "📦 Building Debian (.deb) package..."
fpm \
  -s dir \
  -t deb \
  -n "$PACKAGE_NAME" \
  -v "$VERSION" \
  --description "ZeroTier-Aware Modular DevOps Suite" \
  --url "https://yourusername.github.io/zt-firewall-suite " \
  --license "MIT" \
  --maintainer "Your Name <you@example.com>" \
  -C pkg-root .

mv *.deb "$OUTPUT_DIR/"

echo "✅ Packages built in $OUTPUT_DIR/"