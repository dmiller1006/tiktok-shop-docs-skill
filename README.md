# tiktok-docs

Local mirror of TikTok Shop's Partner Center docs + a Claude Code skill that answers TSP/API questions from them, with citations.

Covers all four portal tabs (Partner Guide, Developer Guide, API Reference, Webhooks), fetched from TikTok's public document API.

The doc `.md` files are **not committed** — `manifest.json` (document_id → filename) is the source of truth. Setup after cloning (any location):

```sh
./install.sh                 # prompts: global / project / skip, then hydrates corpus
./install.sh --project DIR   # non-interactive: install the skill into DIR/.claude/skills
./install.sh --skip-skill    # non-interactive: hydrate the corpus only
./install.sh --global        # non-interactive: install to ~/.claude/skills
```

Run with no flag and it prompts where to install (defaults to global; falls back to global automatically when not attached to a terminal, e.g. in CI).

The skill is copied (not symlinked), so `git pull` never changes it silently — re-run `install.sh` to apply skill updates. `$CLAUDE_SKILLS_DIR` overrides the global skills dir.

## Commands

- `python3 refresh.py` — fetch every doc in `manifest.json`; only changed files are rewritten, and changes are reported
- `python3 refresh.py --search <text>` — search the full portal tree (~770 docs) by title/section for docs to add
- `python3 refresh.py --add <url-or-id>` — add a single page to the manifest and fetch it (docv2 URLs can be pasted as-is)
- `python3 refresh.py --add-tree <url-or-id>` — add a page or folder plus all its descendants

[`INDEX.md`](INDEX.md) is the committed table of contents — every mirrored doc grouped by portal section. It regenerates on every `refresh.py` run; commit it together with `manifest.json` whenever coverage changes. `refresh.py --gaps` diffs the manifest against TikTok's live tree to prove nothing is missing.

Stdlib-only Python 3, no auth required. Each mirrored doc carries frontmatter: `document_id`, `section` (its path in the portal sidebar), `tiktok_updated` (TikTok's edit date), and `retrieved` (last verified against TikTok). Commit `manifest.json` changes after adding docs.

## Claude Code skill

`skills/tiktok-shop-docs/SKILL.md` grounds answers in this corpus. It reads the corpus path from a CORPUS_ROOT file written at install time, so any clone location works. `install.sh` respects `$CLAUDE_SKILLS_DIR` if your skills live somewhere other than `~/.claude/skills`.

Doc content is TikTok's and is not committed — this repo ships only the tooling and index; hydrate the corpus locally with `refresh.py`.
