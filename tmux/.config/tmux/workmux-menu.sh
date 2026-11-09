#!/usr/bin/env bash
set -euo pipefail

action=${1:?missing action}

fail() {
    printf '\n%s\n' "$*" >&2
    read -r -p 'Press Enter to close. ' _ || true
    exit 1
}

git rev-parse --show-toplevel >/dev/null 2>&1 || fail 'Open this menu from a Git repository.'
command -v workmux >/dev/null || fail 'workmux is not installed.'

case "$action" in
    add|prompt)
        read -r -p 'New branch name: ' branch || exit 0
        [[ -n $branch ]] || exit 0
        git check-ref-format --branch "$branch" >/dev/null 2>&1 || fail 'Invalid branch name.'
        if [[ $action == prompt ]]; then
            read -r -p 'Prompt for Codex: ' prompt || exit 0
            [[ -n $prompt ]] || exit 0
            workmux add "$branch" --prompt "$prompt" || fail 'Workmux could not create the worktree.'
        else
            workmux add "$branch" || fail 'Workmux could not create the worktree.'
        fi
        ;;
    branch)
        command -v fzf >/dev/null || fail 'fzf is not installed.'
        branch=$(git for-each-ref --sort=-committerdate --format='%(refname:short)' refs/heads/ | fzf --reverse --prompt='Existing branch> ') || exit 0
        [[ -n $branch ]] || exit 0
        workmux add "$branch" --open-if-exists || fail 'Workmux could not open the branch.'
        ;;
    open|remove|close)
        command -v fzf >/dev/null || fail 'fzf is not installed.'
        command -v jq >/dev/null || fail 'jq is not installed.'
        entries=$(workmux list --json | jq -r '.[] | select(.is_main | not) | [.handle, .branch, (if .is_open then "open" else "closed" end)] | @tsv') || fail 'Workmux could not list worktrees.'
        [[ -n $entries ]] || fail 'No feature worktrees found in this repository.'
        selection=$(printf '%s\n' "$entries" | fzf --reverse --delimiter=$'\t' --with-nth=1,2,3 --prompt="$action worktree> " --header='worktree  branch  status') || exit 0
        handle=${selection%%$'\t'*}
        [[ -n $handle ]] || exit 0
        workmux "$action" "$handle" || fail "Workmux could not $action the worktree."
        ;;
    *) fail "Unknown action: $action" ;;
esac
