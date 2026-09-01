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
