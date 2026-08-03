# Isolate Application Policy Navigation Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use `superpowers:executing-plans` to implement this plan task-by-task. Execute inline and do not dispatch subagents.

**Goal:** Ensure every application policy directory is an isolated publication boundary while preserving same-application language navigation and required external links.

**Architecture:** Keep the root index as a one-way discovery surface. Encode a directory-level anchor boundary in the existing site validator, then remove the root-index anchors from application pages without duplicating shared visual assets.

**Tech Stack:** HTML5, Bash, ripgrep

## Global Constraints

- Do not change AudioLoop policy content, canonical URLs, metadata, or language links.
- Do not modify Timekeeper, Hobgoblin, MergeLong, README, or the site index.
- Preserve existing unrelated working-tree changes under `scripts/` and `tmp/`.
- Do not create branches or Git commits.

---

### Task 1: Remove AudioLoop's site-wide navigation link

**Files:**

- Modify: `scripts/validate-site.sh`
- Modify: `docs/audioloop/index.html`
- Modify: `docs/audioloop/en.html`
- Modify: `docs/audioloop/zh-cn.html`

**Interfaces:**

- Consumes: the existing AudioLoop English, Simplified Chinese, and English redirect pages.
- Produces: AudioLoop navigation containing language links only, enforced by `scripts/validate-site.sh`.

- [x] **Step 1: Add the failing navigation-boundary assertion**

After the shared stylesheet checks in `scripts/validate-site.sh`, add:

```bash
for page in "$DOCS_ROOT"/audioloop/*.html; do
    reject_pattern "$page" 'href="\.\./"|all-policies|全部政策'
done
```

- [x] **Step 2: Run the validator and verify the expected failure**

Run:

```bash
bash "scripts/validate-site.sh"
```

Expected: non-zero exit reporting forbidden content in an AudioLoop HTML page because each page still contains its home link.

- [x] **Step 3: Remove the three home-link anchors**

Delete exactly these anchors and retain the surrounding `<nav>` elements and language links:

```html
<a class="home-link" href="../">./all-policies</a>
<a class="home-link" href="../">./全部政策</a>
```

- [x] **Step 4: Run all validators**

Run:

```bash
bash "scripts/validate-site.sh"
bash "scripts/validate-hobgoblin-pages.sh"
bash "scripts/validate-timekeeper-pages.sh"
```

Expected: all three commands exit `0` and report 12 site pages, 5 Hobgoblin pages, and 3 Timekeeper pages validated.

- [x] **Step 5: Verify the focused diff**

Run:

```bash
git diff --check
git diff -- "docs/audioloop" "scripts/validate-site.sh"
```

Expected: no whitespace errors; the functional diff contains one new validator loop and deletion of one anchor from each AudioLoop page.

### Task 2: Extend isolation to every application

**Files:**

- Modify: `scripts/validate-site.sh`
- Modify: `docs/mergelong/index.html`

**Interfaces:**

- Consumes: application pages below `docs/timekeeper/`, `docs/hobgoblin/`, `docs/audioloop/`, and `docs/mergelong/`.
- Produces: a one-way site index and application pages whose anchors cannot escape their own publication directory.

- [x] **Step 1: Expand the failing isolation assertion**

Replace the AudioLoop-only validator loop with:

```bash
app_directories=(timekeeper hobgoblin audioloop mergelong)
for app_directory in "${app_directories[@]}"; do
    for page in "$DOCS_ROOT/$app_directory"/*.html; do
        reject_pattern "$page" '<a[^>]+href="\.\./|<a[^>]+href="https://privacy-policy\.328064\.xyz/(timekeeper|hobgoblin|audioloop|mergelong)/|all-policies|全部政策'
    done
done
```

- [x] **Step 2: Run the validator and verify the expected failure**

Run:

```bash
bash "scripts/validate-site.sh"
```

Expected: non-zero exit identifying `docs/mergelong/index.html`, which still contains an anchor to `../`.

- [x] **Step 3: Remove MergeLong's root-index anchor**

Delete exactly this anchor while retaining the terms content and canonical URL:

```html
<a class="home-link" href="../">./all-policies</a>
```

Remove the now-empty `<nav aria-label="Document navigation">` wrapper so the page contains no empty landmark.

- [x] **Step 4: Run all validators**

Run:

```bash
bash "scripts/validate-site.sh"
bash "scripts/validate-hobgoblin-pages.sh"
bash "scripts/validate-timekeeper-pages.sh"
```

Expected: all three commands exit `0` and report 12 site pages, 5 Hobgoblin pages, and 3 Timekeeper pages validated.

- [x] **Step 5: Verify the application boundaries and focused diff**

Run:

```bash
if rg -n '<a[^>]+href="\.\./|all-policies|全部政策' "docs/timekeeper" "docs/hobgoblin" "docs/audioloop" "docs/mergelong" -g '*.html'; then exit 1; fi
git diff --check
git diff -- "docs/mergelong/index.html" "scripts/validate-site.sh"
```

Expected: no boundary violations or whitespace errors; the functional diff contains the generalized validator and removal of MergeLong's empty navigation block.
