# tiktok-docs

Sync pipeline for a local mirror of the TikTok Shop Partner Center doc portal (Partner Guide, Developer Guide, API Reference, Webhooks), fetched from TikTok's public document API. Grounds the `tiktok-tsp` Claude Code skill.

The doc `.md` files are **not committed** — `manifest.json` (document_id → filename) is the source of truth. After cloning, hydrate the corpus:

```sh
python3 refresh.py
```

## Commands

- `python3 refresh.py` — fetch every doc in `manifest.json`; only changed files are rewritten, and changes are reported
- `python3 refresh.py --search <text>` — search the full portal tree (~770 docs) by title/section for docs to add
- `python3 refresh.py --add <url-or-id>` — add a single page to the manifest and fetch it (docv2 URLs can be pasted as-is)
- `python3 refresh.py --add-tree <url-or-id>` — add a page or folder plus all its descendants

Stdlib-only Python 3, no auth required. Each mirrored doc carries frontmatter: `document_id`, `section` (its path in the portal sidebar), `tiktok_updated` (TikTok's edit date), and `retrieved` (last verified against TikTok). Commit `manifest.json` changes after adding docs.

## Claude Code skill

`skills/tiktok-tsp/SKILL.md` is the skill that grounds answers in this corpus. Activate it by symlinking into your user skills:

```sh
ln -s ~/code/tiktok-docs/skills/tiktok-tsp ~/.claude/skills/tiktok-tsp
```

(The skill expects the corpus at `~/code/tiktok-docs`.)

Doc content is TikTok's — keep this repo private and the corpus local.
