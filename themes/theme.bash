# Source this file in interactive Bash to update the current shell as well.
theme() {
    command theme "$@" || return
    if [[ -f "$HOME/.config/terminal-theme/starship.toml" ]]; then
        export STARSHIP_CONFIG="$HOME/.config/terminal-theme/starship.toml"
    fi
}
