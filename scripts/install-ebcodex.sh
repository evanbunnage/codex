#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CARGO_DIR="$ROOT_DIR/codex-rs"
INSTALL_DIR="${INSTALL_DIR:-$HOME/.local/bin}"
PROFILE="${PROFILE:-release}"

case "$PROFILE" in
  release)
    BUILD_ARGS=(--release)
    BIN_PATH="$CARGO_DIR/target/release/codex"
    ;;
  debug)
    BUILD_ARGS=()
    BIN_PATH="$CARGO_DIR/target/debug/codex"
    ;;
  *)
    echo "Unsupported PROFILE: $PROFILE" >&2
    echo "Use PROFILE=release or PROFILE=debug" >&2
    exit 1
    ;;
esac

mkdir -p "$INSTALL_DIR"

(
  cd "$CARGO_DIR"
  cargo build "${BUILD_ARGS[@]}" -p codex-cli --bin codex
)

install -m 0755 "$BIN_PATH" "$INSTALL_DIR/ebcodex"

echo "Installed ebcodex to $INSTALL_DIR/ebcodex"
