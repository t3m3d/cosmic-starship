#!/usr/bin/env sh
set -eu

script_dir=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
source_file="$script_dir/starship.toml"
target=${STARSHIP_CONFIG:-"$HOME/.config/starship.toml"}
target_dir=$(dirname "$target")
init_file="$target_dir/cosmic-starship.zsh"
zshrc=${ZDOTDIR:-$HOME}/.zshrc

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

# Stem starts the user's interactive zsh, so install a small, idempotent zsh
# hook as well as the theme. Keeping the hook in ~/.config lets future theme
# installs update it without repeatedly rewriting ~/.zshrc.
escaped_target=$(printf '%s' "$target" | sed "s/'/'\\\\''/g")
init_temporary="$init_file.cosmic-$$.tmp"
{
    printf "export STARSHIP_CONFIG='%s'\n" "$escaped_target"
    printf '%s\n' 'if command -v starship >/dev/null 2>&1; then'
    printf '%s\n' '    eval "$(starship init zsh)"'
    printf '%s\n' 'fi'
} >"$init_temporary"
mv -f "$init_temporary" "$init_file"

marker='# cosmic-starship prompt'
source_line='[ -r "$HOME/.config/cosmic-starship.zsh" ] && source "$HOME/.config/cosmic-starship.zsh"'
if [ "$init_file" != "$HOME/.config/cosmic-starship.zsh" ]; then
    escaped_init=$(printf '%s' "$init_file" | sed "s/'/'\\\\''/g")
    source_line="[ -r '$escaped_init' ] && source '$escaped_init'"
fi
if [ ! -f "$zshrc" ] || ! grep -F "$marker" "$zshrc" >/dev/null 2>&1; then
    if [ -f "$zshrc" ]; then
        stamp=$(date '+%Y%m%d-%H%M%S')
        cp "$zshrc" "$zshrc.backup-$stamp"
    else
        mkdir -p "$(dirname "$zshrc")"
        : >"$zshrc"
    fi
    printf '\n%s\n%s\n' "$marker" "$source_line" >>"$zshrc"
fi

printf 'Installed cosmic-starship to %s\n' "$target"
printf 'Configured Starship startup for zsh in %s\n' "$zshrc"
if ! command -v starship >/dev/null 2>&1; then
    printf 'Warning: Starship is not on PATH. On macOS, run: brew install starship\n' >&2
fi
printf 'Use MesloLGS Nerd Font (or another Nerd Font) for every icon.\n'
