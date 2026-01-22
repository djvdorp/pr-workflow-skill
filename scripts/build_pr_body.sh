#!/usr/bin/env bash
set -euo pipefail

harness="${AGENT_HARNESS:-}"
if [[ -z "$harness" ]]; then
  if [[ -n "${CODEX_MODEL:-}" || -d "${HOME}/.codex" ]]; then
    harness="codex"
  elif [[ -n "${CLAUDE_MODEL:-}" || -d "${HOME}/.claude" ]]; then
    harness="claude"
  elif [[ -n "${CURSOR_MODEL:-}" || -d "${HOME}/Library/Application Support/Cursor" ]]; then
    harness="cursor"
  else
    harness="unknown"
  fi
fi

model="${CODEX_MODEL:-${OPENAI_MODEL:-${ANTHROPIC_MODEL:-${CLAUDE_MODEL:-${CURSOR_MODEL:-${LLM_MODEL:-unknown}}}}}}"
thinking="${THINKING_LEVEL:-${CODEX_THINKING_LEVEL:-${OPENAI_THINKING_LEVEL:-unknown}}}"

codex_config="${CODEX_CONFIG_PATH:-${HOME}/.codex/config.toml}"
if [[ ("$model" == "unknown" || "$thinking" == "unknown") && -f "$codex_config" ]]; then
  if [[ "$model" == "unknown" ]]; then
    config_model="$(awk -F'"' '/^model[[:space:]]*=/ {print $2; exit}' "$codex_config" || true)"
    if [[ -n "$config_model" ]]; then
      model="$config_model"
    fi
  fi
  if [[ "$thinking" == "unknown" ]]; then
    config_thinking="$(awk -F'"' '/^model_reasoning_effort[[:space:]]*=/ {print $2; exit}' "$codex_config" || true)"
    if [[ -n "$config_thinking" ]]; then
      thinking="$config_thinking"
    fi
  fi
fi

terminal="${TERM_PROGRAM:-${LC_TERMINAL:-unknown}}"
terminal_ver="${TERM_PROGRAM_VERSION:-${LC_TERMINAL_VERSION:-}}"
if [[ -n "$terminal_ver" ]]; then
  terminal="${terminal} ${terminal_ver}"
fi

system="$(uname -s)"
if [[ "$system" == "Darwin" && -x /usr/bin/sw_vers ]]; then
  system="macOS $(/usr/bin/sw_vers -productVersion)"
elif command -v lsb_release >/dev/null 2>&1; then
  system="$(lsb_release -ds 2>/dev/null || uname -sr)"
else
  system="$(uname -sr)"
fi

cat <<EOF_OUT
Harness: ${harness}
Model: ${model}
Thinking level: ${thinking}
Terminal: ${terminal}
System: ${system}
EOF_OUT
