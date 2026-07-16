#!/usr/bin/env sh
set -eu

script_dir=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
source_file="$script_dir/starship.toml"
target=${STARSHIP_CONFIG:-"$HOME/.config/starship.toml"}
target_dir=$(dirname "$target")

if [ ! -f "$source_file" ]; then
    printf 'Theme file not found: %s\n' "$source_file" >&2
    exit 1
fi

mkdir -p "$target_dir"

if [ -f "$target" ]; then
    stamp=$(date '+%Y%m%d-%H%M%S')
    backup="$target.backup-$stamp"
    cp "$target" "$backup"
    printf 'Backed up existing config to %s\n' "$backup"
fi

temporary="$target.cosmic-$$.tmp"
trap 'rm -f "$temporary"' EXIT HUP INT TERM
cp "$source_file" "$temporary"
mv -f "$temporary" "$target"
trap - EXIT HUP INT TERM

printf 'Installed cosmic-starship to %s\n' "$target"
if ! command -v starship >/dev/null 2>&1; then
    printf 'Warning: Starship is not on PATH. Install it before starting a new shell.\n' >&2
fi
printf 'Use MesloLGS Nerd Font (or another Nerd Font) for every icon.\n'

