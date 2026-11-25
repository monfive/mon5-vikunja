# mon5 fork

## Branches

- `main`: mirror of `go-vikunja/vikunja` `main`. It only ever gets upstream commits, never ours.
- `mon5`: our main and the GitHub default branch. This is what we deploy.
- Feature branches: start from `mon5` and open PRs back into `mon5`.

Keep changes frontend-only where possible, and keep fork-only files under `mon5/`, so upstream merges stay conflict-free.

## Syncing upstream

The org ruleset on `main` blocks direct pushes except for org admins (bypass). As an org admin:

```sh
git fetch upstream
git push origin upstream/main:main   # fast-forward only; fails if main ever diverges
gh pr create -B mon5 -H main --title "chore: merge upstream into mon5"   # resolve conflicts here
```

Without the bypass, push `upstream/main` to a `sync-upstream-<date>` branch and open a PR into `main` instead.

## CI

All upstream workflows are disabled on the fork (`gh workflow disable`, a GitHub setting, so upstream syncs don't undo it). The only workflow is `.github/workflows/mon5.yml`: frontend lint, stylelint, typecheck, unit tests and build, on PRs and pushes to `mon5`.

**The backend is not tested here.** We don't change it, and upstream's CI tests it before it reaches `main`. If we ever touch the backend (`pkg/`, migrations, etc.), revisit this: add API tests on sqlite and postgres (see `test-api` in `.github/workflows/test.yml`) to `mon5.yml`.

To re-enable an upstream workflow: `gh workflow enable "<name>"`.

## Deploy

On the VM, the checkout must be on `mon5` (`git switch mon5`). Then run `mon5/deploy.sh <compose-dir>`.
