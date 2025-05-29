#!/bin/bash

set -e

OUTPUT_DIR="dist"
PACKAGE_NAME="zt-firewall"
VERSION="1.0.0"

mkdir -p "$OUTPUT_DIR"
rm -rf pkg-root || true
mkdir -p pkg-root/{usr/local/bin,opt/zt-firewall/etc}

# Copy files
cp bin/fwctl pkg-root/usr/local/bin/
cp -r rules lib services install-firewall.sh "$OUTPUT_DIR/"

# Create package root
cp -r rules lib services install-firewall.sh pkg-root/opt/zt-firewall/

echo "📦 Building Debian (.deb) package..."
fpm \
  -s dir \
  -t deb \
  -n "$PACKAGE_NAME" \
  -v "$VERSION" \
  --description "ZeroTier-Aware Modular Firewall" \
  --url "https://github.com/yourusername/zt-firewall " \
  --license "MIT" \
  --maintainer "Your Name <you@example.com>" \
  -C pkg-root .

mv *.deb "$OUTPUT_DIR/"

echo "📦 Building RPM (.rpm) package..."
fpm \
  -s dir \
  -t rpm \
  -n "$PACKAGE_NAME" \
  -v "$VERSION" \
  --description "ZeroTier-Aware Modular Firewall" \
  --url "https://github.com/yourusername/zt-firewall " \
  --license "MIT" \
  --maintainer "Your Name <you@example.com>" \
  -C pkg-root .

mv *.rpm "$OUTPUT_DIR/"

if [[ "$(uname)" == "Darwin" ]]; then
  echo "📦 Building macOS .pkg..."
  pkgbuild \
    --identifier com.yourname.zt-firewall \
    --install-location /opt/zt-firewall \
    --root pkg-root \
    "$OUTPUT_DIR/$PACKAGE_NAME.pkg"
fi

echo "✅ Packages built in $OUTPUT_DIR/"