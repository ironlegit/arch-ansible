#!/usr/bin/env bash
# update-kde-dotfiles.sh
#
# Pulls the live config files that make up your desktop theme back into
# roles/<role>/templates/, and rewrites any hardcoded home-directory path
# to {{ ansible_facts['user_dir'] }} so nothing username-specific ends up
# committed to the repo.
#
# Run this ON your Arch desktop, from the repo root, whenever you tweak
# the theme and want to capture the changes.

set -euo pipefail

# ---- adjust these to match your layout ----
ROLE_DIR="roles/kde-theme"
# --------------------------------------------

TEMPLATES_DIR="$ROLE_DIR/templates"
FILES_DIR="$ROLE_DIR/files"

if [[ ! -d "$TEMPLATES_DIR" ]]; then
  echo "Error: $TEMPLATES_DIR does not exist. Check ROLE_DIR at the top of this script." >&2
  exit 1
fi

# live path -> template filename (relative to templates/)
declare -A CONFIG_MAP=(
  ["$HOME/.config/starship.toml"]="starship.toml.j2"
  ["$HOME/.config/konsolerc"]="konsolerc.j2"
  ["$HOME/.local/share/konsole/main_zsh.profile"]="main_zsh.profile.j2"
  ["$HOME/.local/share/konsole/Sweet-Ambar-Blue.colorscheme"]="Sweet-Ambar-Blue.colorscheme.j2"
  ["$HOME/.config/kdeglobals"]="kdeglobals.j2"
  ["$HOME/.config/plasmarc"]="plasmarc.j2"
  ["$HOME/.config/plasma-org.kde.plasma.desktop-appletsrc"]="plasma-org.kde.plasma.desktop-appletsrc.j2"
  ["$HOME/.config/kwinrc"]="kwinrc.j2"
  ["$HOME/.config/plasmashellrc"]="plasmashellrc.j2"
)

echo "== Syncing config files into $TEMPLATES_DIR =="
for live_path in "${!CONFIG_MAP[@]}"; do
  template_name="${CONFIG_MAP[$live_path]}"
  dest="$TEMPLATES_DIR/$template_name"

  if [[ ! -f "$live_path" ]]; then
    echo "  skip:   $live_path (not found)"
    continue
  fi

  cp "$live_path" "$dest"

  # Replace any occurrence of your literal home dir with the Jinja variable.
  # Harmless no-op on files that don't contain it.
  sed -i "s#$HOME#{{ ansible_facts['user_dir'] }}#g" "$dest"

  echo "  synced: $live_path -> $dest"
done

# ---- wallpaper: follow whatever appletsrc currently points to ----
echo
echo "== Syncing wallpaper =="
APPLETSRC="$HOME/.config/plasma-org.kde.plasma.desktop-appletsrc"
if [[ -f "$APPLETSRC" ]]; then
  WALLPAPER_URI=$(grep -m1 "^Image=" "$APPLETSRC" | cut -d= -f2-)
  WALLPAPER_PATH="${WALLPAPER_URI#file://}"

  if [[ -n "$WALLPAPER_PATH" && -f "$WALLPAPER_PATH" ]]; then
    mkdir -p "$FILES_DIR"
    cp "$WALLPAPER_PATH" "$FILES_DIR/$(basename "$WALLPAPER_PATH")"
    echo "  synced: $WALLPAPER_PATH -> $FILES_DIR/$(basename "$WALLPAPER_PATH")"
    echo "  NOTE: if the filename changed, update 'src:' in your wallpaper copy task,"
    echo "        and confirm its 'dest:' still matches the path now templated into"
    echo "        plasma-org.kde.plasma.desktop-appletsrc.j2."
  else
    echo "  warning: wallpaper file referenced in appletsrc not found at: $WALLPAPER_PATH"
  fi
else
  echo "  warning: $APPLETSRC not found, skipping wallpaper sync"
fi

# ---- show what changed, if this is a git repo ----
if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo
  echo "== git status for templates/ and files/ =="
  git status --short "$TEMPLATES_DIR" "$FILES_DIR" 2>/dev/null || true
fi

echo
echo "Done. Review the diffs above (or 'git diff') before committing."
