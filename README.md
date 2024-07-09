# Shared dotfile repository

## ! Moving to a canvas-based dotfile manager, see refactor branch for some updates

Dotfiles are managed by GNU stow internally; yadm to-be-evaluated
- https://www.gnu.org/software/stow/
- https://yadm.io/
- https://gist.github.com/wizioo/c89847c7894ede628071

Dotfile-related resources / must read
- https://dotfiles.github.io/

## Installation

```
$ git clone git@github/path/to/dotfiles ~/.dotfiles

# Full installation wizzard
$ ~/.dotfiles/dot.sh install

# Install a dotfile individually
$ ~/.dotfiles/dot.sh install audacious
$ ~/.dotfiles/dot.sh install shell
$ ~/.dotfiles/dot.sh install bash

# Per-dotfile installation via stow
$ stow -d $HOME/.dotfiles/ -t $HOME --ignore=install.sh audacious
$ stow -d $HOME/.dotfiles/ -t $HOME --ignore=install.sh shell
$ stow -d $HOME/.dotfiles/ -t $HOME --ignore=install.sh bash
```

Installation of the shell and bash modules will add two management aliaeses:

- **dot**: Alias for the dot installation utility
- **dotfiles**: Convenient wrapper for the git command to manage your dotfiles repository

Some dotfiles require additional installation steps(we don't ship fonts, another good example is oh-my-zsh), those can be installed individually by running ``install.sh`` from the respective dotfile directory.
This file is excluded from the dotfile installation.

## Usage

```
$ dotfiles status
..snip..
Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
	modified:   README.md
	modified:   shell/.shell/aliases
	modified:   shell/.shell/env

$ dotfiles commit -am "Update of shell aliases"
$ dotfiles push
```
## Packages
- https://github.com/junegunn/fzf
- https://github.com/ogham/exa
- https://github.com/sharkdp/fd
- https://github.com/sharkdp/bat
- https://github.com/Peltoche/lsd
- https://github.com/BurntSushi/ripgrep
- https://github.com/dandavison/delta


## TODO
- Installation templating for the {{ USER }} to $USER variable
- Pre-commit hook to replace $USER with {{ USER }}
