#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "Usage: bash scripts/install_deccan_lords_skills.sh /absolute/path/to/godot-project" >&2
  exit 2
fi

SOURCE_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PROJECT_INPUT="$1"

if [[ ! -d "$PROJECT_INPUT" ]]; then
  echo "ERROR: Project directory does not exist: $PROJECT_INPUT" >&2
  exit 2
fi
PROJECT_DIR="$(cd "$PROJECT_INPUT" && pwd)"

if [[ ! -f "$PROJECT_DIR/project.godot" ]]; then
  echo "ERROR: No project.godot found in: $PROJECT_DIR" >&2
  echo "Open/create the Godot project first, then run this installer again." >&2
  exit 2
fi

SKILL_SOURCE="$SOURCE_ROOT/skills"
SKILL_DEST="$PROJECT_DIR/.agents/skills"
SKILL_NAMES=(
  "deccan-lords-director"
  "deccan-lords-gameplay-simulation"
  "deccan-lords-visual-assets"
  "deccan-lords-ui-ux"
  "deccan-lords-audio-feedback"
  "deccan-lords-debug-profiler"
  "deccan-lords-qa-release"
)

# Preflight all source and destination paths before copying anything.
for name in "${SKILL_NAMES[@]}"; do
  if [[ ! -f "$SKILL_SOURCE/$name/SKILL.md" ]]; then
    echo "ERROR: Skill source missing: $SKILL_SOURCE/$name/SKILL.md" >&2
    exit 2
  fi
  if [[ -e "$SKILL_DEST/$name" ]]; then
    echo "ERROR: Destination already exists: $SKILL_DEST/$name" >&2
    echo "No files were copied. Review/remove the existing skill directory before retrying." >&2
    exit 2
  fi
done

mkdir -p "$SKILL_DEST"
for name in "${SKILL_NAMES[@]}"; do
  cp -R "$SKILL_SOURCE/$name" "$SKILL_DEST/$name"
  echo "Installed: $SKILL_DEST/$name"
done

echo
echo "Installed ${#SKILL_NAMES[@]} DECCAN LORDS project skills."
echo "Next: open this Godot project in Codex and ask it to use deccan-lords-director."
echo "The installer did not install MCP servers, packages, assets, or API keys."
