#!/usr/bin/env sh
# Start the DeepSeek Harness Web UI at http://127.0.0.1:3080
# Extra arguments are passed to `dsh web` (e.g. ./start-harness.sh --port 4000 --no-open)
set -e

if ! command -v node >/dev/null 2>&1; then
  echo "error: Node.js is required (v22.19+ or v24+). Install it from https://nodejs.org/" >&2
  exit 1
fi

NODE_MAJOR=$(node -p 'process.versions.node.split(".")[0]')
if [ "$NODE_MAJOR" -lt 22 ]; then
  echo "error: Node.js v22.19+ or v24+ is required (found $(node --version))." >&2
  exit 1
fi

# Version this setup was verified against; override with DSH_VERSION=latest for the newest release.
DSH_VERSION="${DSH_VERSION:-0.1.1-rc.2}"

echo "Starting DeepSeek Harness (@deepseek-ai/dsh@${DSH_VERSION}) — the first run downloads the package and can take a few minutes..."

# pnpm resolves this package's large rc dependency graph in seconds where npm's
# resolver can grind for a very long time, so prefer pnpm when it is available.
if command -v pnpm >/dev/null 2>&1; then
  exec pnpm dlx "@deepseek-ai/dsh@${DSH_VERSION}" web "$@"
else
  echo "note: if this hangs on 'resolving dependencies', install pnpm (npm i -g pnpm) and rerun — this script will use it automatically." >&2
  exec npx -y "@deepseek-ai/dsh@${DSH_VERSION}" web "$@"
fi
