# tiktok-docs

Local mirror of the TikTok Shop Partner Center doc portal (all four tabs), synced via `refresh.py` from TikTok's public document API. Grounds the `tiktok-tsp` Claude Code skill.

- `python3 refresh.py` — re-fetch everything in `manifest.json`; only changed files are rewritten, so `git diff` after a refresh shows exactly what TikTok edited
- `python3 refresh.py --search <text>` — search the full portal tree for docs to add
- `python3 refresh.py --add <url-or-id>` / `--add-tree <url-or-id>` — add a page / a section recursively

Content is TikTok's — keep this repo private.
