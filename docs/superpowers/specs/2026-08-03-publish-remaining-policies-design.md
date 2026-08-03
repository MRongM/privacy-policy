# Publish Remaining Policies Design

## Goal

Publish the repository's unmounted AudioLoop privacy policies and MergeLong terms as static pages, expose every public document URL in the repository README, and preserve existing published URLs.

## Scope

- Publish AudioLoop privacy policies in English and Simplified Chinese.
- Publish the existing English MergeLong Terms & Conditions.
- Preserve the concurrently added Hourly Chime / Timekeeper pages without modifying their content.
- List Timekeeper, Hobgoblin, AudioLoop, and MergeLong public document links in `README.md`.
- Update the site index so all four applications are discoverable.
- Keep the source Markdown files unchanged.
- Do not rewrite the legal meaning of the source documents.
- Do not add JavaScript, a build system, external fonts, or third-party runtime dependencies.

## Public URLs

| Application | Document | Language | URL |
| --- | --- | --- | --- |
| Hourly Chime / 整点报时 | Privacy Policy | English | `https://privacy-policy.328064.xyz/timekeeper/` |
| Hourly Chime / 整点报时 | Privacy Policy | Simplified Chinese | `https://privacy-policy.328064.xyz/timekeeper/zh-cn.html` |
| Hobgoblin Android | Privacy Policy | English | `https://privacy-policy.328064.xyz/hobgoblin/` |
| Hobgoblin Android | Privacy Policy | Simplified Chinese | `https://privacy-policy.328064.xyz/hobgoblin/zh-cn.html` |
| Hobgoblin Android | Privacy Policy | Japanese | `https://privacy-policy.328064.xyz/hobgoblin/ja.html` |
| Hobgoblin Android | Privacy Policy | Korean | `https://privacy-policy.328064.xyz/hobgoblin/ko.html` |
| AudioLoop | Privacy Policy | English | `https://privacy-policy.328064.xyz/audioloop/` |
| AudioLoop | Privacy Policy | Simplified Chinese | `https://privacy-policy.328064.xyz/audioloop/zh-cn.html` |
| MergeLong | Terms & Conditions | English | `https://privacy-policy.328064.xyz/mergelong/` |

`/audioloop/en.html` will remain an English compatibility entry and redirect to `/audioloop/`, matching the existing Hobgoblin convention. Redirect aliases are not listed as primary README links.

## Architecture

The site remains a dependency-free GitHub Pages static site under `docs/`:

- `docs/privacy.css` is the shared visual stylesheet.
- `docs/audioloop/index.html` is the canonical English AudioLoop policy.
- `docs/audioloop/en.html` redirects to the canonical English policy.
- `docs/audioloop/zh-cn.html` is the Simplified Chinese AudioLoop policy.
- `docs/mergelong/index.html` is the canonical English MergeLong terms page.
- `docs/index.html` links to each application document, including the existing Timekeeper pages discovered during implementation.
- `README.md` is the repository-facing URL index.

Existing Hobgoblin pages will reference the shared stylesheet. The previous `docs/hobgoblin/privacy.css` path will become a small compatibility stylesheet importing the shared file, avoiding a destructive deletion while keeping one authoritative set of style declarations.

## Content Rules

AudioLoop HTML follows the existing Markdown meaning and only resolves placeholders:

- Application: AudioLoop
- Developer: MRongM
- Contact: `jiangisright@gmail.com`
- Effective date: 2025-03-01

MergeLong remains explicitly labeled `Terms & Conditions`, not Privacy Policy, and retains its existing effective date of 2024-09-28.

Pages use semantic headings and sections, meaningful metadata, canonical URLs, language navigation where applicable, visible keyboard focus, and a mobile-friendly layout. Every application directory is a standalone publication boundary: application pages may link to languages and compatibility pages inside the same application, email contacts, and required external policies, but must not link back to the site-wide policy index or to another application. The root index remains a one-way discovery surface that can link into each application. Shared CSS is an implementation asset and does not weaken the navigation boundary.

## Data Flow and Failure Handling

There is no client-side or server-side data flow. GitHub Pages serves immutable HTML and CSS files. Relative internal links keep local preview and custom-domain deployment behavior aligned. Missing files, broken expected links, placeholder text, incorrect canonical URLs, and accidental third-party runtime dependencies are treated as build-time validation failures.

## Validation Strategy

Implementation follows a red-green cycle:

1. Add a site-wide validation script that describes the expected README links, routes, metadata, content markers, placeholder removal, language navigation, and shared stylesheet usage.
2. Run it before adding pages and confirm it fails because the new pages are absent.
3. Add the minimum static files and index/README changes needed to pass.
4. Run both the new site-wide validator and the existing Hobgoblin validator.
5. Scan all published HTML for unfinished placeholders and validate local links.

The validator rejects application-page anchors that traverse to a parent directory, absolute anchors into this site's application routes, and the labels `all-policies` or `全部政策`. This enforces the standalone boundary for Timekeeper, Hobgoblin, AudioLoop, MergeLong, and future pages added inside those directories.

No browser runtime test framework is introduced because the pages have no interactive behavior; deterministic shell validation is sufficient for the current static architecture.

## Non-goals

- Legal review or substantive rewriting of policy language.
- Adding new languages.
- Adding analytics, cookies, forms, JavaScript, or a content management system.
- Changing the custom domain or GitHub Pages deployment mechanism.
- Git commits, branches, or pushes.
