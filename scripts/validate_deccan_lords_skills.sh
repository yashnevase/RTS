#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SKILL_ROOT="$ROOT/skills"
SKILL_NAMES=(
  "deccan-lords-director"
  "deccan-lords-gameplay-simulation"
  "deccan-lords-visual-assets"
  "deccan-lords-ui-ux"
  "deccan-lords-audio-feedback"
  "deccan-lords-debug-profiler"
  "deccan-lords-qa-release"
)

fail() {
  echo "FAIL: $*" >&2
  exit 1
}

[[ -f "$ROOT/scripts/install_deccan_lords_skills.sh" ]] || fail "installer not found"
bash -n "$ROOT/scripts/install_deccan_lords_skills.sh" || fail "installer shell syntax"

for name in "${SKILL_NAMES[@]}"; do
  skill_file="$SKILL_ROOT/$name/SKILL.md"
  [[ -f "$skill_file" ]] || fail "missing $skill_file"
  [[ "$(head -n 1 "$skill_file")" == "---" ]] || fail "$skill_file has no YAML frontmatter"
  declared_name="$(sed -n 's/^name:[[:space:]]*//p' "$skill_file" | head -n 1 | tr -d '"' | tr -d "'")"
  [[ "$declared_name" == "$name" ]] || fail "$skill_file declares name '$declared_name', expected '$name'"
  grep -q '^description:[[:space:]]*[^[:space:]]' "$skill_file" || fail "$skill_file has no description"
done

# Smoke-test installation and safe refusal to overwrite, in a disposable temp project.
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT
PROJECT_DIR="$TMP_DIR/game"
mkdir -p "$PROJECT_DIR"
printf 'config_version=5\n' > "$PROJECT_DIR/project.godot"

bash "$ROOT/scripts/install_deccan_lords_skills.sh" "$PROJECT_DIR" > "$TMP_DIR/install.log" || fail "installer failed on a clean test project"

skill_count=0
for path in "$PROJECT_DIR/.agents/skills"/deccan-lords-*; do
  [[ -d "$path" ]] || continue
  [[ -f "$path/SKILL.md" ]] || fail "installed skill lacks SKILL.md: $path"
  skill_count=$((skill_count + 1))
done
[[ "$skill_count" -eq "${#SKILL_NAMES[@]}" ]] || fail "expected ${#SKILL_NAMES[@]} installed skills, found $skill_count"

if bash "$ROOT/scripts/install_deccan_lords_skills.sh" "$PROJECT_DIR" > "$TMP_DIR/reinstall.log" 2>&1; then
  fail "installer unexpectedly overwrote existing skills"
fi
grep -q 'No files were copied' "$TMP_DIR/reinstall.log" || fail "reinstall refusal message missing"

echo "PASS: ${#SKILL_NAMES[@]} skill frontmatter entries validated."
echo "PASS: installer shell syntax checked."
echo "PASS: project-local install smoke test succeeded."
echo "PASS: repeat install safely refused to overwrite existing skill directories."
