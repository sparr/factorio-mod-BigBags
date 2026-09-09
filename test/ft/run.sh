#!/usr/bin/env bash
# Integration tier: drive the real game and check what it actually did.
#
#   test/ft/run.sh              # headless, whole suite
#   test/ft/run.sh -v           # with the game's own log lines
#   test/ft/run.sh "equipment"  # only tests matching a Lua pattern
#
# BB_FACTORIO   the game binary, if it is not where this expects
# BB_FT_DATA    the throwaway data directory the run happens in
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$root"

factorio="${BB_FACTORIO:-$HOME/.local/share/factorio-versions/2.1.17/bin/x64/factorio}"
# Deliberately outside the repo: the CLI symlinks the mod under test into this directory's
# mods folder, and a data directory inside the repo would make the repo contain itself.
data="${BB_FT_DATA:-$HOME/.cache/bigbags-factorio-test}"
[[ -x node_modules/.bin/factorio-test ]] || { echo "run: npm install" >&2; exit 2; }
[[ -x "$factorio" ]] || { echo "no factorio binary at $factorio" >&2; exit 2; }

mkdir -p "$data/mods"
ln -sfn "$root/test/ft/bb-tests" "$data/mods/bb-tests"

exec node_modules/.bin/factorio-test run \
    --factorio-path "$factorio" \
    --data-directory "$data" \
    --output-file "$data/results.json" \
    "$@"
