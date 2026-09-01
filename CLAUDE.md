# CLAUDE.md

## About this repository

- Personal academic homepage based on the Beautiful Jekyll theme, deployed via GitHub Pages.
- Owner: Joonseok Yang, Assistant Professor, Department of Political Science and International Studies, Yonsei University.

## Workflow rules

- Never commit directly to the `main` branch. Always work on a feature/working branch.
- After making changes, always verify with a local Jekyll build before committing.
- Commit messages: a single line in English, including the reason for the change.
- After committing completed work, always push the branch — do not let local commits accumulate unpushed.
- Before creating or merging a PR, verify that the origin branch points to the same commit as the local branch (`git rev-parse <branch> origin/<branch>`).
- When stating a commit count in a PR body, count from the PR's actual head commit, not the local branch.

## Local build vs GitHub Pages build

- GitHub Pages ignores the Gemfile and builds with the `github-pages` gem
  (Jekyll 3.10.x + jekyll-seo-tag 2.8), while local builds use Jekyll 4.x.
- Pages enables extra plugins that are absent locally — notably
  `jekyll-optional-front-matter` (converts `.md` files WITHOUT front matter into
  pages), `jekyll-readme-index`, `jekyll-relative-links`,
  `jekyll-titles-from-headings`. A stray `.md` file that is a static file
  locally can become a published page (and a sitemap entry) on Pages.
- Therefore the local sitemap and the live sitemap can differ: after every
  deploy, check https://joonsyang.github.io/sitemap.xml against expectations.
- Keep non-content `.md` files either excluded in `_config.yml` or out of the
  repo entirely.
