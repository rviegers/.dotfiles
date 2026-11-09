# Dotfiles

Application configurations are organized as [GNU Stow](https://www.gnu.org/software/stow/) packages. From this directory, link a package into your home directory with:

```sh
stow -t "$HOME" tmux workmux
```

Stow does not overwrite existing files. Move or back up any conflicting files before linking a package. To remove a package's links, run `stow -D -t "$HOME" <package>`.

