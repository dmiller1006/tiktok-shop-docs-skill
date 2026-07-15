#!/bin/sh
# Install the tiktok-tsp Claude Code skill (symlink) and hydrate the doc corpus.
set -e
ROOT=$(cd "$(dirname "$0")" && pwd)
SKILLS_DIR="${CLAUDE_SKILLS_DIR:-$HOME/.claude/skills}"

mkdir -p "$SKILLS_DIR"
if [ -e "$SKILLS_DIR/tiktok-tsp" ] && [ ! -L "$SKILLS_DIR/tiktok-tsp" ]; then
  echo "error: $SKILLS_DIR/tiktok-tsp exists and is not a symlink; remove it first" >&2
  exit 1
fi
ln -sfn "$ROOT/skills/tiktok-tsp" "$SKILLS_DIR/tiktok-tsp"
echo "skill linked: $SKILLS_DIR/tiktok-tsp -> $ROOT/skills/tiktok-tsp"

echo "hydrating doc corpus (first run takes a few minutes)..."
python3 "$ROOT/refresh.py"
echo "done — ask Claude Code anything about TikTok Shop Partner Center, or invoke /tiktok-tsp"
