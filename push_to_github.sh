#!/usr/bin/env bash
# One-shot helper: initialise git and push this folder to your GitHub repo.
# Run from inside the INT-333 folder:  bash push_to_github.sh
set -euo pipefail
REPO_URL="https://github.com/MuhammedShaanTT/INT-333.git"

[[ -d .git ]] || git init -b main
git add .
git commit -m "Add INT333 notes, practicals, cheatsheets and lab setup" || true
git remote remove origin 2>/dev/null || true
git remote add origin "$REPO_URL"
git pull origin main --rebase --allow-unrelated-histories || true   # merges the README GitHub may have created
git push -u origin main
