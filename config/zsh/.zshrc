# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Case Insensitive Autocompletion + history options
autoload -Uz compinit && compinit -d ~/.config/.zcompdump
setopt no_case_glob
setopt share_history
setopt hist_ignore_all_dups

# fzf-zoxide integration
function fzf_zoxide() { 
    LBUFFER+=$(zoxide query --list | fzf --reverse --height=40%)
    zle reset-prompt
}
zle -N fzf_zoxide

# Keybindings
bindkey -e
bindkey '^o' fzf_zoxide
bindkey "^H" backward-kill-word
bindkey "^[[3;5~" kill-word
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word
bindkey "^[[3~" delete-char

# Useful Aliases
alias n="nvim"
alias g="lazygit"
alias rm="trash"
alias cd="z"
alias fd="fd --hidden --no-ignore"
alias ls="ls --color=auto -1"
alias ll="ls -Ahl"
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias venv="source venv/bin/activate || python -m venv venv && source venv/bin/activate"
function md() { mkdir -p "$1" && cd "$1" }
function o() { xdg-open $1 &> /dev/null &}

# git aliases
alias gs="git status --short"
alias gaa="git add"
alias gaa="git add --all"
alias gc="git commit --message"
alias gca="git commit --all --message"
alias gsw="git switch"
alias gswc="git switch --create"
alias gd="git diff"
alias gl="git log --graph --decorate --oneline"
alias gl="git pull"
alias gp="git push"
alias gwipe="git reset --hard HEAD && git clean -fd"
alias gwip='git add -A; git rm $(git ls-files --deleted) 2> /dev/null; git commit --no-verify --no-gpg-sign --message "--wip-- [skip ci]"'
alias gunwip='git rev-list --max-count=1 --format="%s" HEAD | grep -q "--wip--" && git reset HEAD~1'

# Bind arrow keys to search history based on the typed command prefix.
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search
bindkey "^[[B" down-line-or-beginning-search

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
