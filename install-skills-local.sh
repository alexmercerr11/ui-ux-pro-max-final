#!/usr/bin/env bash
# install-skills-local.sh
# Installs ui-ux-pro-max and marketing skills into your local Claude Code CLI.
# Run once: bash install-skills-local.sh

set -euo pipefail

SKILLS_DIR="$HOME/.claude/skills"
REPOS_DIR="$HOME/.claude/skill-repos"

echo "Setting up Claude Code skills..."

mkdir -p "$SKILLS_DIR" "$REPOS_DIR"

clone_or_pull() {
  local url="$1"
  local name="$2"
  local dest="$REPOS_DIR/$name"
  if [ -d "$dest/.git" ]; then
    echo "  Updating $name..."
    git -C "$dest" pull --ff-only --quiet
  else
    echo "  Cloning $name..."
    git clone --depth=1 --quiet "$url" "$dest"
  fi
}

clone_or_pull "https://github.com/alexmercerr11/ui-ux-pro-max-final.git" "ui-ux-pro-max-final"
clone_or_pull "https://github.com/alexmercerr11/marketingskills-final.git" "marketingskills-final"

echo "  Linking UI/UX skills..."
for skill_dir in "$REPOS_DIR/ui-ux-pro-max-final/.claude/skills"/*/; do
  [ -d "$skill_dir" ] || continue
  ln -sfn "$skill_dir" "$SKILLS_DIR/$(basename "$skill_dir")"
done

echo "  Linking marketing skills..."
for skill_dir in "$REPOS_DIR/marketingskills-final/skills"/*/; do
  [ -d "$skill_dir" ] || continue
  ln -sfn "$skill_dir" "$SKILLS_DIR/$(basename "$skill_dir")"
done

echo ""
echo "Done! $(ls "$SKILLS_DIR" | wc -l | tr -d ' ') skills installed:"
ls "$SKILLS_DIR"
echo ""
echo "All skills are now available in Claude Code CLI."
echo "Run 'claude' in any project and use /skill-name to invoke them."
