#!/usr/bin/env bash
# Convenience entry to process all open issues fully autonomously via Codex CLI
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
"$DIR/issue_orchestrate_auto.sh" --all --limit 999999 --merge
