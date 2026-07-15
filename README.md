# tiktok-docs

Local mirror of TikTok Shop's Partner Center docs + a Claude Code skill that answers TSP/API questions from them, with citations.

Covers all four portal tabs (Partner Guide, Developer Guide, API Reference, Webhooks), fetched from TikTok's public document API.

The doc `.md` files are **not committed** — `manifest.json` (document_id → filename) is the source of truth. Setup after cloning (any location):

```sh
./install.sh   # links the Claude Code skill into ~/.claude/skills and hydrates the corpus
```

Or manually: `python3 refresh.py` to hydrate, and symlink `skills/tiktok-tsp` into your skills directory.

## Commands

- `python3 refresh.py` — fetch every doc in `manifest.json`; only changed files are rewritten, and changes are reported
- `python3 refresh.py --search <text>` — search the full portal tree (~770 docs) by title/section for docs to add
- `python3 refresh.py --add <url-or-id>` — add a single page to the manifest and fetch it (docv2 URLs can be pasted as-is)
- `python3 refresh.py --add-tree <url-or-id>` — add a page or folder plus all its descendants

Stdlib-only Python 3, no auth required. Each mirrored doc carries frontmatter: `document_id`, `section` (its path in the portal sidebar), `tiktok_updated` (TikTok's edit date), and `retrieved` (last verified against TikTok). Commit `manifest.json` changes after adding docs.

## Claude Code skill

`skills/tiktok-tsp/SKILL.md` grounds answers in this corpus. It locates the corpus relative to its own real path, so any clone location works. `install.sh` respects `$CLAUDE_SKILLS_DIR` if your skills live somewhere other than `~/.claude/skills`.

Doc content is TikTok's — keep this repo private and the corpus local.
