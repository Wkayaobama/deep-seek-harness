@echo off
rem Start the DeepSeek Harness Web UI at http://127.0.0.1:3080
rem Extra arguments are passed to `dsh web` (e.g. start-harness.cmd --port 4000 --no-open)

where node >nul 2>nul
if errorlevel 1 (
  echo error: Node.js is required ^(v22.19+ or v24+^). Install it from https://nodejs.org/
  exit /b 1
)

rem Version this setup was verified against; set DSH_VERSION=latest for the newest release.
if "%DSH_VERSION%"=="" set DSH_VERSION=0.1.1-rc.2

echo Starting DeepSeek Harness (@deepseek-ai/dsh@%DSH_VERSION%) — the first run downloads the package and can take a few minutes...

rem pnpm resolves this package's large rc dependency graph in seconds where npm's
rem resolver can grind for a very long time, so prefer pnpm when it is available.
where pnpm >nul 2>nul
if errorlevel 1 (
  echo note: if this hangs on "resolving dependencies", install pnpm ^(npm i -g pnpm^) and rerun — this script will use it automatically.
  npx -y @deepseek-ai/dsh@%DSH_VERSION% web %*
) else (
  pnpm dlx @deepseek-ai/dsh@%DSH_VERSION% web %*
)
