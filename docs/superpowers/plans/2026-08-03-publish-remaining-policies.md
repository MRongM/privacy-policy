# Publish Remaining Policies Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use `superpowers:executing-plans` to implement this plan task-by-task. This plan is intentionally executed inline; do not dispatch subagents.

**Goal:** Publish AudioLoop privacy policies and MergeLong terms as static pages, then document every canonical public document URL, including the concurrently added Timekeeper pages, in `README.md`.

**Architecture:** Keep GitHub Pages dependency-free under `docs/`. Use semantic static HTML, one authoritative root stylesheet, a compatibility stylesheet at the former Hobgoblin asset path, and a deterministic shell validator as the executable site contract.

**Tech Stack:** HTML5, CSS, Bash, ripgrep, GitHub Pages

## Global Constraints

- Preserve all existing Hobgoblin public URLs.
- Preserve the user-authored Timekeeper pages and public URLs discovered during implementation.
- Preserve the legal meaning and source order of `AudioLoop_en.md`, `AudioLoop_zh.md`, and `MergeLong.md`.
- Resolve AudioLoop values to `AudioLoop`, `MRongM`, `jiangisright@gmail.com`, and `2025-03-01`.
- Keep MergeLong's effective date `2024-09-28` and label it `Terms & Conditions`.
- Do not add JavaScript, a build system, external fonts, or third-party runtime dependencies.
- Keep source Markdown files unchanged.
- Do not create branches or Git commits.

---

### Task 1: Publish and validate all static documents

**Files:**

- Create: `scripts/validate-site.sh`
- Create: `docs/privacy.css`
- Create: `docs/audioloop/index.html`
- Create: `docs/audioloop/en.html`
- Create: `docs/audioloop/zh-cn.html`
- Create: `docs/mergelong/index.html`
- Create: `README.md`
- Modify: `docs/index.html`
- Modify: `docs/hobgoblin/index.html`
- Modify: `docs/hobgoblin/en.html`
- Modify: `docs/hobgoblin/zh-cn.html`
- Modify: `docs/hobgoblin/ja.html`
- Modify: `docs/hobgoblin/ko.html`
- Modify: `docs/hobgoblin/privacy.css`
- Test: `scripts/validate-site.sh`
- Regression test: `scripts/validate-hobgoblin-pages.sh`
- Regression test: `scripts/validate-timekeeper-pages.sh`

**Interfaces:**

- Consumes: static source documents at repository root and the custom domain from `docs/CNAME`.
- Produces: canonical public routes under `/timekeeper/`, `/hobgoblin/`, `/audioloop/`, and `/mergelong/`; the complete route index in `README.md`; exit status `0` from all validation scripts.

- [x] **Step 1: Write the failing site contract**

Create `scripts/validate-site.sh` with strict shell settings and assertions for:

```bash
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
```

- [x] **Step 2: Run the contract and confirm the expected red state**

Run:

```bash
bash "scripts/validate-site.sh"
```

Expected: non-zero exit with `Privacy site validation failed: missing or empty .../README.md` because publishing files do not exist yet.

- [x] **Step 3: Establish the shared stylesheet**

Copy the complete current declarations from `docs/hobgoblin/privacy.css` into `docs/privacy.css`. Add only the small rules needed by the site index and document navigation: a compact unstyled document list, a muted document-type label, and consistent back-link spacing. Change every Hobgoblin HTML stylesheet reference from `privacy.css` to `../privacy.css`. Replace `docs/hobgoblin/privacy.css` with this compatibility shim:

```css
@import url("../privacy.css");
```

- [x] **Step 4: Create the AudioLoop pages**

Create canonical English and Simplified Chinese pages using the existing Hobgoblin semantic structure: skip link, `.shell`, header, application/developer mark, title, summary, two-language navigation, `main#policy`, effective-date/developer metadata, one `<section>` per numbered source heading, and footer. Transcribe every source heading, paragraph, and list item in its original order.

Apply these exact source substitutions:

| Source value | Published value |
| --- | --- |
| `[Insert Date]` / `[插入日期]` | `2025-03-01` |
| `[AudioLoop]` / `[您的应用名称]` | `AudioLoop` |
| `[Insert Contact Information]` / `[插入联系方式]` | linked `jiangisright@gmail.com` |
| `[您的公司名称][您的电子邮件地址][您的地址]` | `MRongM` plus linked `jiangisright@gmail.com` |

Use these canonical links:

```html
<link rel="canonical" href="https://privacy-policy.328064.xyz/audioloop/" />
<link rel="canonical" href="https://privacy-policy.328064.xyz/audioloop/zh-cn.html" />
```

Create `docs/audioloop/en.html` as a no-script redirect matching the Hobgoblin English alias, with `http-equiv="refresh"`, canonical `/audioloop/`, the shared stylesheet, developer/contact/date markers, and links to both languages.

- [x] **Step 5: Create the MergeLong terms page**

Create `docs/mergelong/index.html` with the same semantic shell and shared stylesheet. Transcribe every paragraph and list item from `MergeLong.md` in source order, preserving both external attribution links. Render visible ampersands as `&amp;`, set canonical `/mergelong/`, show `2024-09-28` in the metadata block, and provide a route back to `../`.

- [x] **Step 6: Update discovery surfaces**

Update `docs/index.html` to use `privacy.css` and include one section each for Hobgoblin Android, AudioLoop, and MergeLong. Identify MergeLong as Terms & Conditions rather than a privacy policy.

Create `README.md` with a concise project description, deployment base URL, and a four-column Markdown table containing the nine canonical document URLs defined in the design. Do not list redirect aliases as canonical documents.

- [x] **Step 7: Run the new validator and reach green**

Run:

```bash
bash "scripts/validate-site.sh"
```

Expected: `Validated 12 published document pages and README links.`

- [x] **Step 8: Run existing regression validation**

Run:

```bash
bash "scripts/validate-hobgoblin-pages.sh"
bash "scripts/validate-timekeeper-pages.sh"
```

Expected: `Validated 5 Hobgoblin privacy pages.`

Expected: `Validated 3 Timekeeper privacy pages.`

- [x] **Step 9: Perform final static checks**

Run:

```bash
if rg -n -i 'TBD|TODO|\[Insert|\[插入|\[您的' "docs" -g '*.html'; then exit 1; fi
git diff --check
git status --short
```

Expected: the unfinished-content scan and `git diff --check` produce no output; `git status --short` lists only the intended design, plan, validator, README, stylesheet, HTML, and existing-page changes.
