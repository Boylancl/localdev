# Repository Guidelines

## Project Structure & Module Organization

- `init.sh` is the root entry point for a full WSL setup run.
- `scripts/system/` contains OS/bootstrap setup (Git, zsh, Homebrew).
- `scripts/agents/` contains agent/tooling installs (Codex, Gemini).
- `scripts/system/add-git-shortcuts.sh` prompts for a shell file (e.g., `~/.bashrc`) and appends Git shortcut functions.
- `docs/` is reserved for setup notes and future troubleshooting guides.

## Repository Layout

```
.
├── AGENTS.md
├── init.sh
├── docs/
└── scripts/
    ├── agents/
    │   ├── install-codex-deps.sh
    │   └── install-gemini-cli.sh
    └── system/
        ├── add-git-shortcuts.sh
        ├── install-brew.sh
        ├── install-zshell.sh
        └── setup-git.sh
```

## Build, Test, and Development Commands

- `./init.sh`: Runs the full setup sequence (Git, zsh, Homebrew, Python/Node deps, agent CLIs). Requires `sudo` and network access.
- `./scripts/system/setup-git.sh`: Installs Git/GitHub CLI, configures global Git settings, and provisions SSH keys.
- `./scripts/agents/install-codex-deps.sh`: Installs system deps, Python venv, Node.js, and Codex CLI.
- `./scripts/system/install-brew.sh`: Installs Homebrew and GCC (Linuxbrew pathing in `.zshrc`).
- `./scripts/system/install-zshell.sh`: Installs zsh and optionally Oh My Zsh.
- `./scripts/agents/install-gemini-cli.sh`: Sets up a Python venv and a simple Gemini CLI wrapper.

## Coding Style & Naming Conventions

- Shell scripts use Bash with `set -euo pipefail` and should remain POSIX-friendly where practical.
- Indentation is 2 spaces for wrapped command lists and heredocs.
- File names are lowercase with hyphens (e.g., `install-codex-deps.sh`).

## Idempotency & Safe Re-Runs

- Scripts must be safe to execute multiple times without breaking a WSL container. Guard installs with `command -v`, `if` checks, or package manager idempotency.
- Avoid destructive actions or overwriting user files without prompts. When adding to shell profiles, check for existing lines.
- If a step is not idempotent (e.g., reinstalling a CLI), document the behavior and provide a safe no-op path.

## Testing Guidelines

- No automated test suite is present. Validate changes by running the relevant script end-to-end in a clean WSL container.
- If you add tests, document how to run them in this section.

## Agent Install Requirements

- Required agents: OpenAI Codex CLI, Gemini CLI wrapper, and Claude Code.
- Codex installs via `npm install -g @openai/codex` in `scripts/agents/install-codex-deps.sh`.
- Gemini installs via `scripts/agents/install-gemini-cli.sh` and expects `GEMINI_API_KEY`.
- Claude Code installs via the upstream script in `init.sh`; verify `~/.local/bin` is on `PATH`.

## Commit & Pull Request Guidelines

- Commit messages are short, lowercase, and descriptive (e.g., "add github cli install", "remove bad file").
- PRs should include a brief summary, affected scripts, and WSL assumptions (Ubuntu version, required `sudo`, network access).
- Include command output or a short verification note when changes alter install flow.

## Security & Configuration Notes

- Scripts routinely call `sudo` and download installers via `curl`. Review URLs before running.
- API keys are expected via environment variables (e.g., `OPENAI_API_KEY`, `GEMINI_API_KEY`). Avoid hardcoding secrets.
