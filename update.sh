#!/usr/bin/env sh
set -eu

script_dir=$(CDPATH= cd -- "$(dirname "$0")" && pwd)

if ! command -v git >/dev/null 2>&1; then
    printf 'Git is required to update cosmic-starship.\n' >&2
    exit 1
fi

if ! git -C "$script_dir" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    printf 'This copy is not a Git checkout. Clone the repository to receive updates:\n' >&2
    printf '  git clone https://github.com/t3m3d/cosmic-starship.git\n' >&2
    exit 1
fi

if [ -n "$(git -C "$script_dir" status --porcelain)" ]; then
    printf 'Local changes found in %s; update stopped to preserve them.\n' "$script_dir" >&2
    printf 'Commit, stash, or discard those changes, then run ./update.sh again.\n' >&2
    exit 1
fi

branch=$(git -C "$script_dir" symbolic-ref --quiet --short HEAD || true)
if [ -z "$branch" ]; then
    printf 'The repository is in detached-HEAD state; switch to main before updating.\n' >&2
    exit 1
fi

printf 'Updating cosmic-starship on %s...\n' "$branch"
git -C "$script_dir" pull --ff-only

if [ ! -f "$script_dir/install.sh" ]; then
    printf 'Updated repository does not contain install.sh.\n' >&2
    exit 1
fi

printf 'Applying the latest prompt...\n'
exec sh "$script_dir/install.sh"
