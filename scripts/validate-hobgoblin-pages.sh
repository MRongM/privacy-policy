#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
PRIVACY_ROOT="${1:-$REPO_ROOT/docs/hobgoblin}"
CANONICAL_URL='https://privacy-policy.328064.xyz/hobgoblin/'

fail() {
    printf 'Hobgoblin privacy page validation failed: %s\n' "$1" >&2
    exit 1
}

required_files=(index.html en.html zh-cn.html ja.html ko.html)
required_links=("./" zh-cn.html ja.html ko.html)

cname_path="$REPO_ROOT/docs/CNAME"
[[ -s "$cname_path" ]] || fail "missing $cname_path"
[[ "$(tr -d '\r\n' < "$cname_path")" == "privacy-policy.328064.xyz" ]] ||
    fail "CNAME does not contain the canonical custom domain"
[[ -f "$REPO_ROOT/docs/.nojekyll" ]] || fail "missing $REPO_ROOT/docs/.nojekyll"
[[ -s "$REPO_ROOT/docs/index.html" ]] || fail "missing $REPO_ROOT/docs/index.html"
rg -Fq 'href="hobgoblin/"' "$REPO_ROOT/docs/index.html" ||
    fail "site index does not link to the Hobgoblin policy"

for name in "${required_files[@]}"; do
    page="$PRIVACY_ROOT/$name"
    [[ -s "$page" ]] || fail "missing $page"

    rg -q 'MRongM' "$page" || fail "$name does not identify MRongM"
    rg -q 'jiangisright@gmail\.com' "$page" || fail "$name does not include the privacy contact"
    rg -q '2026-07-27' "$page" || fail "$name does not include the effective date"
    rg -qi 'Termux' "$page" || fail "$name does not disclose Termux behavior"
    rg -qi 'retention|保留|保持|保管|보관' "$page" || fail "$name does not cover retention"
    rg -qi 'delet|删除|削除|삭제' "$page" || fail "$name does not cover deletion"

    for link in "${required_links[@]}"; do
        rg -Fq "href=\"$link\"" "$page" || fail "$name does not link to $link"
    done

    if rg -qi 'TBD|TODO|\[Insert|example\.com' "$page"; then
        fail "$name contains unfinished or example content"
    fi
done

[[ -s "$PRIVACY_ROOT/privacy.css" ]] || fail "missing $PRIVACY_ROOT/privacy.css"
rg -Fq "<link rel=\"canonical\" href=\"$CANONICAL_URL\"" "$PRIVACY_ROOT/index.html" ||
    fail "index.html does not declare the canonical URL"

if rg -q 'mrongm\.github\.io/hobgoblin/privacy' "$PRIVACY_ROOT"; then
    fail "privacy source contains the obsolete canonical URL"
fi

printf 'Validated 5 Hobgoblin privacy pages.\n'
