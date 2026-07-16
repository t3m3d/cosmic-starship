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
sh ./install.sh
```

Both installers use `STARSHIP_CONFIG` when it is set. Otherwise they install to
`~/.config/starship.toml`. An existing configuration is copied to a timestamped
backup before replacement.

Open a new shell after installation. Existing Starship sessions usually pick up
the configuration on the next prompt.

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
