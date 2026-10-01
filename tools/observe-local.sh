#!/usr/bin/env bash
# Observe progress of the local-only v2-research branch from another PC (read-only).
# Usage: tools/observe-local.sh user@PC_LOCAL /path/to/racsm60fps [branch]
# Needs SSH access to the PC that holds the project. Nothing is published to GitHub.
set -euo pipefail

HOST="${1:?usage: observe-local.sh user@host /remote/repo/path [branch]}"
REPO="${2:?usage: observe-local.sh user@host /remote/repo/path [branch]}"
BRANCH="${3:-v2-research}"

echo "=== Step 1: CURRENT_STATE.md (checkpoint) ==="
ssh "$HOST" "cd '$REPO' && stat -c 'Last modified: %y' CURRENT_STATE.md && echo && cat CURRENT_STATE.md"

echo
echo "=== Step 2: recent commits on $BRANCH (read-only) ==="
ssh "$HOST" "cd '$REPO' && git log '$BRANCH' --oneline -15 && echo && git status -sb | head -20"

# Optional: fetch the branch into this PC's repo (read-only remote, no push).
if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  git remote get-url pc-local >/dev/null 2>&1 || git remote add pc-local "$HOST:$REPO"
  git remote set-url --push pc-local DISABLED
  git fetch pc-local "$BRANCH"
  echo
  echo "Fetched. Compare with:  git log pc-local/$BRANCH --oneline"
  echo "                        git diff HEAD..pc-local/$BRANCH -- CURRENT_STATE.md"
fi
