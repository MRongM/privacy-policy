#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
POLICY_ROOT="${1:-$REPO_ROOT/docs/timekeeper}"
CANONICAL_URL='https://privacy-policy.328064.xyz/timekeeper/'

fail() {
    printf 'Timekeeper privacy page validation failed: %s\n' "$1" >&2
    exit 1
}

required_pages=(index.html en.html zh-cn.html)
required_links=("./" zh-cn.html)

cname_path="$REPO_ROOT/docs/CNAME"
[[ -s "$cname_path" ]] || fail "missing $cname_path"
[[ "$(tr -d '\r\n' < "$cname_path")" == "privacy-policy.328064.xyz" ]] ||
    fail "CNAME does not contain the canonical custom domain"
[[ -f "$REPO_ROOT/docs/.nojekyll" ]] || fail "missing $REPO_ROOT/docs/.nojekyll"
[[ -s "$REPO_ROOT/docs/index.html" ]] || fail "missing $REPO_ROOT/docs/index.html"
rg -Fq 'href="timekeeper/"' "$REPO_ROOT/docs/index.html" ||
    fail "site index does not link to the Timekeeper policy"

for name in "${required_pages[@]}"; do
    page="$POLICY_ROOT/$name"
    [[ -s "$page" ]] || fail "missing $page"

    rg -q 'MRongM' "$page" || fail "$name does not identify MRongM"
    rg -q 'jiangisright@gmail\.com' "$page" || fail "$name does not include the privacy contact"
    rg -q '2026-08-03' "$page" || fail "$name does not include the effective date"
    rg -qi 'collect|收集' "$page" || fail "$name does not cover data collection"
    rg -qi 'retention|保留' "$page" || fail "$name does not cover retention"
    rg -qi 'delet|删除' "$page" || fail "$name does not cover deletion"

    for link in "${required_links[@]}"; do
        rg -Fq "href=\"$link\"" "$page" || fail "$name does not link to $link"
    done

    if rg -qi 'TBD|TODO|\[Insert|example\.com' "$page"; then
        fail "$name contains unfinished or example content"
    fi
done

[[ -s "$POLICY_ROOT/privacy.css" ]] || fail "missing $POLICY_ROOT/privacy.css"
rg -Fq "<link rel=\"canonical\" href=\"$CANONICAL_URL\"" \
    "$POLICY_ROOT/index.html" || fail "index.html does not declare the canonical URL"

printf 'Validated 3 Timekeeper privacy pages.\n'
