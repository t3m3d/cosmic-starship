# cosmic-starship

An outer-space Starship prompt for Windows, macOS, and Linux, piloted by
`t3m3d` and colored to match the Krypton terminal theme.

## What it shows

- a `t3m3d` spacecraft identity capsule on every prompt;
- the current platform icon: Windows, Apple, or Linux;
- directory, Git branch/state, command duration, exit status, and local time;
- a GitHub icon only when a repository has a `github.com` remote; and
- contextual Node.js, Python, Rust, Go, .NET, Java, Kotlin, Lua, Swift, and
  Docker modules.

The GitHub detector uses portable `git config` commands. Starship runs them
through the native command shell on Windows and through `sh` on macOS/Linux.

## Requirements

- [Starship](https://starship.rs/) 1.20 or newer
- Git for repository detection
- [MesloLGS Nerd Font](https://www.nerdfonts.com/font-downloads), or another
  Nerd Font with Powerline and GitHub glyphs

Set the Nerd Font as the terminal face on every machine. The color palette is
part of this repository, but font selection belongs to the terminal emulator.

## Install

### Windows PowerShell

```powershell
git clone https://github.com/t3m3d/cosmic-starship.git
Set-Location .\cosmic-starship
.\install.ps1
```

### macOS or Linux

```sh
git clone https://github.com/t3m3d/cosmic-starship.git
cd cosmic-starship
./install.sh
```

If macOS reports `permission denied`, restore the executable permission and run
the installer again:

```sh
chmod +x install.sh
./install.sh
```

You can also run it without changing the file permission:

```sh
sh ./install.sh
```

If macOS blocks a downloaded copy because it is quarantined, inspect the file
first and then remove the quarantine attribute from this script only:

```sh
xattr -l install.sh
xattr -d com.apple.quarantine install.sh
./install.sh
```

Install Starship itself first if it is not already available:

```sh
brew install starship
```

Both installers use `STARSHIP_CONFIG` when it is set. Otherwise they install to
`~/.config/starship.toml`. An existing configuration is copied to a timestamped
backup before replacement.

On macOS, `install.sh` also creates an idempotent zsh initialization hook and
adds it to `~/.zshrc`. This is the shell Stem launches, so Cosmic Starship is
active in new Stem panes, tabs, and windows. Existing `.zshrc` files are backed
up before the hook is added. If Starship itself is missing, install it with
`brew install starship` and open a new Stem window.

Open a new shell after installation. Existing Starship sessions usually pick up
the configuration on the next prompt.

## Update on macOS or Linux

From an existing Git clone, run:

```sh
cd cosmic-starship
./update.sh
```

The updater works from any current directory when invoked with its path. It
fast-forwards the current branch, preserves local changes by stopping before a
pull, and then reapplies the latest prompt with `install.sh`. If executable
permissions were lost, use `sh ./update.sh` or restore them with
`chmod +x update.sh`.

## Platform identity

| Platform | Prompt mark |
|---|---|
| Windows | `` |
| macOS | `` |
| Linux | `` |
| GitHub remote | `` |

If the symbols above appear as boxes, select a Nerd Font in the terminal.

## Customize

The named colors live under `[palettes.krypton]` in `starship.toml`. Change the
palette there without rewriting every module. The main structure is controlled
by the top-level `format` string.

## License

MIT
