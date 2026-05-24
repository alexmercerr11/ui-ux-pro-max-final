#!/usr/bin/env bash
# install-skills-local.sh
# Installs UI/UX Pro Max and Marketing skills into your local Claude Code CLI.
#
# SAFE USAGE — download and review before running:
#   curl -fsSL https://raw.githubusercontent.com/alexmercerr11/ui-ux-pro-max-final/claude/dreamy-tesla-Ywd8U/install-skills-local.sh -o install-skills-local.sh
#   cat install-skills-local.sh   # review it
#   bash install-skills-local.sh

set -euo pipefail

SKILLS_DIR="$HOME/.claude/skills"
REPOS_DIR="$HOME/.claude/skill-repos"

echo "Setting up Claude Code skills..."

mkdir -p "$SKILLS_DIR" "$REPOS_DIR"

clone_or_pull() {
  local url="$1" name="$2" dest="$REPOS_DIR/$2"
  if [ -d "$dest/.git" ]; then
    echo "  Updating $name..."
    git -C "$dest" pull --ff-only --quiet
  else
    echo "  Cloning $name..."
    git clone --depth=1 --quiet "$url" "$dest"
  fi
}

clone_or_pull "https://github.com/alexmercerr11/ui-ux-pro-max-final.git"  "ui-ux-pro-max-final"
clone_or_pull "https://github.com/alexmercerr11/marketingskills-final.git" "marketingskills-final"

echo "  Linking UI/UX skills..."
for d in "$REPOS_DIR/ui-ux-pro-max-final/.claude/skills"/*/; do
  [ -d "$d" ] && ln -sfn "$d" "$SKILLS_DIR/$(basename "$d")"
done

echo "  Linking marketing skills..."
for d in "$REPOS_DIR/marketingskills-final/skills"/*/; do
  [ -d "$d" ] && ln -sfn "$d" "$SKILLS_DIR/$(basename "$d")"
done

echo ""
echo "Done! $(ls "$SKILLS_DIR" | wc -l | tr -d ' ') skills installed."
echo "Restart Claude Code — all skills will be available immediately."
