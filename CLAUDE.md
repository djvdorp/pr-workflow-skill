# Claude Code Installation

This file contains explicit instructions for installing this skill in Claude Code.

## Quick Install (for Claude)

Give Claude this prompt:

> Install the PR workflow skill from https://github.com/djvdorp/pr-workflow-skill. Create a plugin at ~/.claude/plugins/pr-workflow-plugin/ with the skill in skills/pr-workflow/, and register it in known_marketplaces.json.

## What Claude Should Do

1. **Clone the repo to a plugin structure:**
   ```bash
   git clone https://github.com/djvdorp/pr-workflow-skill.git ~/.claude/plugins/pr-workflow-plugin/skills/pr-workflow
   ```

2. **Create plugin metadata:**
   ```bash
   mkdir -p ~/.claude/plugins/pr-workflow-plugin/.claude-plugin
   ```

   Create `~/.claude/plugins/pr-workflow-plugin/.claude-plugin/plugin.json`:
   ```json
   {
     "name": "pr-workflow",
     "description": "High-signal PR and commit workflow with human-written intent enforcement",
     "author": {"name": "djvdorp"}
   }
   ```

3. **Register local plugins** in `~/.claude/plugins/known_marketplaces.json`:
   ```json
   {
     "local": {
       "source": {"source": "local"},
       "installLocation": "/home/daniel/.claude/plugins"
     }
   }
   ```

## Why This Structure?

Claude Code discovers skills through plugins, not standalone directories. The required structure is:

```
~/.claude/plugins/
└── pr-workflow-plugin/
    ├── .claude-plugin/
    │   └── plugin.json
    └── skills/
        └── pr-workflow/
            ├── SKILL.md
            ├── references/
            └── scripts/
```

## Verification

After installation, the skill should auto-activate when you ask to:
- "create a commit"
- "make a pull request"
- "create a PR"
- "commit these changes"

The skill's `description` in `SKILL.md` contains trigger phrases that Claude uses for auto-discovery.
