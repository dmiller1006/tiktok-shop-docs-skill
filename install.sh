#!/bin/sh
# Install the tiktok-tsp Claude Code skill and hydrate the doc corpus.
#
# The skill is COPIED into your skills dir, so updates are explicit: pull the
# repo, then re-run this script to apply skill changes. Nothing you execute
# changes passively on `git pull`.
set -e
ROOT=$(cd "$(dirname "$0")" && pwd)
SKILLS_DIR="${CLAUDE_SKILLS_DIR:-$HOME/.claude/skills}"
DEST="$SKILLS_DIR/tiktok-tsp"

# replace an old symlink from a prior install so we don't cp back into the repo
[ -L "$DEST" ] && rm "$DEST"
mkdir -p "$DEST"
cp "$ROOT/skills/tiktok-tsp/SKILL.md" "$DEST/SKILL.md"
printf '%s\n' "$ROOT" > "$DEST/CORPUS_ROOT"
echo "skill copied: $DEST/SKILL.md (re-run install to update)"

echo "hydrating doc corpus (first run takes a few minutes)..."
python3 "$ROOT/refresh.py"
echo "done — ask Claude Code anything about TikTok Shop Partner Center, or invoke /tiktok-tsp"
