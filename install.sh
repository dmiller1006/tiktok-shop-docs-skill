#!/bin/sh
# Install the tiktok-shop-docs Claude Code skill and hydrate the doc corpus.
#
# The skill is COPIED into your skills dir, so updates are explicit: pull the
# repo, then re-run this script to apply skill changes. Nothing you execute
# changes passively on `git pull`.
#
# Usage:
#   ./install.sh                 install to global skills (~/.claude/skills)
#   ./install.sh --project DIR   install to DIR/.claude/skills (project-scoped)
#   ./install.sh --skip-skill    hydrate the corpus only, don't install the skill
#
# $CLAUDE_SKILLS_DIR overrides the global skills dir.
set -e
ROOT=$(cd "$(dirname "$0")" && pwd)

SKILLS_DIR="${CLAUDE_SKILLS_DIR:-$HOME/.claude/skills}"
INSTALL_SKILL=1

set_project() {
  [ -n "$1" ] || { echo "error: project directory required" >&2; exit 1; }
  [ -d "$1" ] || { echo "error: no such directory: $1" >&2; exit 1; }
  SKILLS_DIR="$(cd "$1" && pwd)/.claude/skills"
}

case "$1" in
  --skip-skill) INSTALL_SKILL=0 ;;
  --project) set_project "$2" ;;
  --global) ;;
  "")
    # No flag: prompt interactively when attached to a terminal, else default global.
    if [ -t 0 ]; then
      echo "Where should the tiktok-shop-docs skill be installed?"
      echo "  1) Global   (${CLAUDE_SKILLS_DIR:-$HOME/.claude/skills})"
      echo "  2) Project  (a project's .claude/skills)"
      echo "  3) Skip     (hydrate the corpus only)"
      printf "Choice [1]: "
      read -r choice
      case "$choice" in
        ""|1) ;;
        2) printf "Project directory: "; read -r projdir; set_project "$projdir" ;;
        3) INSTALL_SKILL=0 ;;
        *) echo "error: invalid choice '$choice'" >&2; exit 1 ;;
      esac
    fi ;;
  *) echo "error: unknown option '$1' (see usage in this script)" >&2; exit 1 ;;
esac

if [ "$INSTALL_SKILL" = "1" ]; then
  DEST="$SKILLS_DIR/tiktok-shop-docs"
  # replace an old symlink from a prior install so we don't cp back into the repo
  [ -L "$DEST" ] && rm "$DEST"
  mkdir -p "$DEST"
  cp "$ROOT/skills/tiktok-shop-docs/SKILL.md" "$DEST/SKILL.md"
  printf '%s\n' "$ROOT" > "$DEST/CORPUS_ROOT"
  echo "skill copied: $DEST/SKILL.md (re-run install to update)"
else
  echo "skipping skill install (--skip-skill)"
fi

echo "hydrating doc corpus (first run takes a few minutes)..."
python3 "$ROOT/refresh.py"
echo "done."
[ "$INSTALL_SKILL" = "1" ] && echo "ask Claude Code about TikTok Shop Partner Center, or invoke /tiktok-shop-docs"
