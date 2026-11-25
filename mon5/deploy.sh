#!/usr/bin/env bash
# Pull the fork, build our Vikunja image and restart the compose stack.
# Usage (on the VM, from anywhere): mon5-vikunja/mon5/deploy.sh <dir-with-docker-compose.yml>
# Rollback: every build is also tagged with its version; retag it as :latest and rerun `docker compose up -d`.
set -euo pipefail

COMPOSE_DIR=${1:?usage: $0 <dir-with-docker-compose.yml>}
COMPOSE_DIR=$(cd "$COMPOSE_DIR" && pwd)
IMAGE=mon5-vikunja

cd "$(dirname "$0")/.."

# main mirrors upstream; deploying it would ship stock Vikunja without our changes.
BRANCH=$(git branch --show-current)
[ "$BRANCH" = mon5 ] || { echo "Checked out '$BRANCH', expected 'mon5' (git switch mon5)" >&2; exit 1; }

git pull --ff-only

# Forks don't carry upstream's release tags; fetch them so the version reads like v2.8.0-81-g<sha>
git remote get-url upstream >/dev/null 2>&1 || git remote add upstream https://github.com/go-vikunja/vikunja.git
git fetch --quiet upstream --tags
# Match only upstream release tags, so other tags (e.g. mon5-backup/*) can't leak into the version / docker tag.
VERSION=$(git describe --tags --always --match 'v[0-9]*')

echo "Building $IMAGE:$VERSION"
docker build -t "$IMAGE:latest" -t "$IMAGE:$VERSION" --build-arg RELEASE_VERSION="$VERSION" .

cd "$COMPOSE_DIR"
docker compose up -d
docker compose ps
echo "Deployed $IMAGE:$VERSION"
