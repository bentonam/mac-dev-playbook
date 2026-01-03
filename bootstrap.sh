#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

echo "==> mac-dev-playbook bootstrap"

if ! xcode-select -p >/dev/null 2>&1; then
  echo "==> Installing Xcode Command Line Tools (GUI prompt will appear)..."
  xcode-select --install || true
  echo "==> Re-run this script after CLT installation completes."
  exit 1
fi

if ! command -v python3 >/dev/null 2>&1; then
  echo "ERROR: python3 not found. On modern macOS, install it (e.g. via Homebrew) and re-run."
  exit 1
fi

echo "==> Ensuring pip is available + up to date (user install)..."
python3 -m ensurepip --user >/dev/null 2>&1 || true
python3 -m pip install --user --upgrade pip >/dev/null

echo "==> Installing Ansible (user install)..."
python3 -m pip install --user --upgrade ansible >/dev/null

PY_USER_BIN="$(python3 -m site --user-base)/bin"
export PATH="${PY_USER_BIN}:${PATH}"

echo "==> Installing Ansible Galaxy requirements..."
ansible-galaxy install -r requirements.yml

echo "==> Bootstrap complete."
echo "Next:"
echo "  ansible-playbook main.yml --ask-become-pass"
