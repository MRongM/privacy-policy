#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
DOCS_ROOT="$REPO_ROOT/docs"
BASE_URL='https://privacy-policy.328064.xyz'

fail() {
    printf 'Privacy site validation failed: %s\n' "$1" >&2
    exit 1
}

require_file() {
    [[ -s "$1" ]] || fail "missing or empty $1"
}

require_text() {
    rg -Fq "$2" "$1" || fail "$1 does not contain $2"
}

reject_pattern() {
    if rg -qi "$2" "$1"; then
        fail "$1 contains forbidden content matching $2"
    fi
}

require_file "$REPO_ROOT/README.md"
require_file "$DOCS_ROOT/index.html"
require_file "$DOCS_ROOT/privacy.css"
[[ -f "$DOCS_ROOT/.nojekyll" ]] || fail "missing $DOCS_ROOT/.nojekyll"
[[ "$(tr -d '\r\n' < "$DOCS_ROOT/CNAME")" == 'privacy-policy.328064.xyz' ]] ||
    fail 'unexpected CNAME value'

for route in timekeeper hobgoblin audioloop mergelong; do
    require_text "$DOCS_ROOT/index.html" "href=\"$route/\""
done
require_text "$DOCS_ROOT/index.html" 'href="privacy.css"'

pages=(
    hobgoblin/index.html
    hobgoblin/en.html
    hobgoblin/zh-cn.html
    hobgoblin/ja.html
    hobgoblin/ko.html
    timekeeper/index.html
    timekeeper/en.html
    timekeeper/zh-cn.html
    audioloop/index.html
    audioloop/en.html
    audioloop/zh-cn.html
    mergelong/index.html
)

for relative_page in "${pages[@]}"; do
    page="$DOCS_ROOT/$relative_page"
    require_file "$page"
    require_text "$page" 'MRongM'
    reject_pattern "$page" 'TBD|TODO|\[Insert|\[插入|\[您的'
    reject_pattern "$page" '<script([[:space:]>])'
done

for page in "$DOCS_ROOT"/hobgoblin/*.html "$DOCS_ROOT"/audioloop/*.html "$DOCS_ROOT"/mergelong/*.html; do
    require_text "$page" 'href="../privacy.css"'
done

app_directories=(timekeeper hobgoblin audioloop mergelong)
for app_directory in "${app_directories[@]}"; do
    for page in "$DOCS_ROOT/$app_directory"/*.html; do
        reject_pattern "$page" '<a[^>]+href="\.\./|<a[^>]+href="https://privacy-policy\.328064\.xyz/(timekeeper|hobgoblin|audioloop|mergelong)/|all-policies|全部政策'
    done
done

require_text "$DOCS_ROOT/audioloop/index.html" "href=\"$BASE_URL/audioloop/\""
require_text "$DOCS_ROOT/audioloop/index.html" '2025-03-01'
require_text "$DOCS_ROOT/audioloop/index.html" 'jiangisright@gmail.com'
require_text "$DOCS_ROOT/audioloop/index.html" 'microphone'
require_text "$DOCS_ROOT/audioloop/index.html" 'href="zh-cn.html"'
require_text "$DOCS_ROOT/audioloop/zh-cn.html" "href=\"$BASE_URL/audioloop/zh-cn.html\""
require_text "$DOCS_ROOT/audioloop/zh-cn.html" '2025-03-01'
require_text "$DOCS_ROOT/audioloop/zh-cn.html" 'jiangisright@gmail.com'
require_text "$DOCS_ROOT/audioloop/zh-cn.html" '麦克风'
require_text "$DOCS_ROOT/audioloop/en.html" 'http-equiv="refresh"'

require_text "$DOCS_ROOT/mergelong/index.html" "href=\"$BASE_URL/mergelong/\""
require_text "$DOCS_ROOT/mergelong/index.html" 'Terms &amp; Conditions'
require_text "$DOCS_ROOT/mergelong/index.html" '2024-09-28'
require_text "$DOCS_ROOT/mergelong/index.html" 'https://policies.google.com/terms'
require_text "$DOCS_ROOT/mergelong/index.html" 'jiangisright@gmail.com'

urls=(
    "$BASE_URL/timekeeper/"
    "$BASE_URL/timekeeper/zh-cn.html"
    "$BASE_URL/hobgoblin/"
    "$BASE_URL/hobgoblin/zh-cn.html"
    "$BASE_URL/hobgoblin/ja.html"
    "$BASE_URL/hobgoblin/ko.html"
    "$BASE_URL/audioloop/"
    "$BASE_URL/audioloop/zh-cn.html"
    "$BASE_URL/mergelong/"
)
for url in "${urls[@]}"; do
    require_text "$REPO_ROOT/README.md" "$url"
done

printf 'Validated %d published document pages and README links.\n' "${#pages[@]}"
