#!/usr/bin/env bash
# Usage: ./scripts/setup-repo.sh owner/repo
# Needs: GitHub CLI (gh) logged in with admin rights on the repo.
set -euo pipefail
REPO="${1:?usage: setup-repo.sh owner/repo}"

echo "Creating develop-2 branch from main (if missing)..."
SHA=$(gh api "repos/$REPO/git/ref/heads/main" --jq .object.sha)
gh api -X POST "repos/$REPO/git/refs" -f ref=refs/heads/develop-2 -f sha="$SHA" 2>/dev/null || echo "develop-2 already exists"

echo "Labels..."
for l in "type:epic:5b4fc7" "type:feature:1d9e75" "type:story:7f77dd" "type:bug:d85a30"; do
  name="${l%:*}"; color="${l##*:}"
  gh label create "$name" --color "$color" --repo "$REPO" --force
done

echo "Environments..."
gh api -X PUT "repos/$REPO/environments/staging" >/dev/null
gh api -X PUT "repos/$REPO/environments/production" >/dev/null

echo "Protect develop-2 (PR + 1 approval + CI)..."
gh api -X PUT "repos/$REPO/branches/develop-2/protection" --input - <<JSON
{
  "required_status_checks": {"strict": true, "contexts": ["branch-name", "lint-and-unit-tests"]},
  "enforce_admins": false,
  "required_pull_request_reviews": {"required_approving_review_count": 1, "require_code_owner_reviews": true, "dismiss_stale_reviews": true},
  "restrictions": null
}
JSON

echo "Protect main (PR + 1 approval, no direct pushes)..."
gh api -X PUT "repos/$REPO/branches/main/protection" --input - <<JSON
{
  "required_status_checks": null,
  "enforce_admins": false,
  "required_pull_request_reviews": {"required_approving_review_count": 1},
  "restrictions": null
}
JSON

echo "Done. Manual: add required reviewers to the 'production' environment, and set repo variable STAGING_URL."
