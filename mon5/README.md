# mon5 fork

## Branches

- `main`: mirror of `go-vikunja/vikunja` `main`. It only ever gets upstream commits, never ours.
- `mon5`: our main and the GitHub default branch. This is what we deploy.
- Feature branches: start from `mon5` and open PRs back into `mon5`.

Keep changes frontend-only where possible, and keep fork-only files under `mon5/`, so upstream merges stay conflict-free.

## Syncing upstream

The org ruleset on `main` requires changes to go through a PR with a merge commit:

```sh
git fetch upstream
git push origin upstream/main:refs/heads/sync-upstream-$(date +%F)
gh pr create -B main -H sync-upstream-$(date +%F) --title "chore: sync main with upstream"
# after merging: PR main -> mon5, resolve any conflicts there
gh pr create -B mon5 -H main --title "chore: merge upstream into mon5"
```

## Deploy

On the VM, the checkout must be on `mon5` (`git switch mon5`). Then run `mon5/deploy.sh <compose-dir>`.
