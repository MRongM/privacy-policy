#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
FIXTURE_ROOT="$(mktemp -d "${TMPDIR:-/tmp}/timekeeper-policy-test.XXXXXX")"
trap 'rm -rf "$FIXTURE_ROOT"' EXIT

cp -R "$REPO_ROOT/docs/timekeeper/." "$FIXTURE_ROOT/"
for page in "$FIXTURE_ROOT"/*.html; do
    perl -pi -e 's/sharing/disclosure/ig; s/share/transfer/ig; s/分享/传递/g' "$page"
done

if bash "$SCRIPT_DIR/validate-timekeeper-pages.sh" "$FIXTURE_ROOT" >/dev/null 2>&1; then
    printf 'Expected validator to reject pages without a data-sharing statement.\n' >&2
    exit 1
fi

printf 'Timekeeper privacy validator rejects a missing sharing statement.\n'
