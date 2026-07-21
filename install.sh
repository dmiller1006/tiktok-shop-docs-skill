#!/bin/sh
# Install the tiktok-tsp Claude Code skill and hydrate the doc corpus.
#
# By default the skill is COPIED into your skills dir, so updates are explicit:
# pull the repo, then re-run this script to apply skill changes. Nothing you
# execute changes passively on `git pull`.
#
# Pass --dev to symlink instead (live-edit loop for maintainers of this repo).
set -e
ROOT=$(cd "$(dirname "$0")" && pwd)
SKILLS_DIR="${CLAUDE_SKILLS_DIR:-$HOME/.claude/skills}"
DEV=0
[ "$1" = "--dev" ] && DEV=1

DEST="$SKILLS_DIR/tiktok-tsp"
mkdir -p "$SKILLS_DIR"

if [ "$DEV" = "1" ]; then
  if [ -e "$DEST" ] && [ ! -L "$DEST" ]; then
    echo "error: $DEST exists and is not a symlink; remove it first" >&2
    exit 1
  fi
  ln -sfn "$ROOT/skills/tiktok-tsp" "$DEST"
  echo "skill linked (dev): $DEST -> $ROOT/skills/tiktok-tsp"
  printf '%s\n' "$ROOT" > "$DEST/CORPUS_ROOT"
else
  if [ -L "$DEST" ]; then
    echo "note: replacing an existing symlink at $DEST with a copy" >&2
    rm "$DEST"
  fi
  rm -rf "$DEST"
  mkdir -p "$DEST"
  cp "$ROOT/skills/tiktok-tsp/SKILL.md" "$DEST/SKILL.md"
  printf '%s\n' "$ROOT" > "$DEST/CORPUS_ROOT"
  echo "skill copied: $DEST/SKILL.md (re-run install to update)"
fi

echo "hydrating doc corpus (first run takes a few minutes)..."
python3 "$ROOT/refresh.py"
echo "done — ask Claude Code anything about TikTok Shop Partner Center, or invoke /tiktok-tsp"
