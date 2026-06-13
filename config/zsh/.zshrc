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

# Plugins
# source <(zoxide init zsh)
# source <(fzf --zsh)
# source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
# source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

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
alias rm="rm -I"
alias fd="fd --hidden --no-ignore"
alias ls="ls --color=auto -1"
alias ll="ls -Ahl"
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias tree="tree -C -L 4"
alias venv="source venv/bin/activate || python -m venv venv && source venv/bin/activate"
alias restow="(cd ~/Repos/dotfiles && stow -vt ~ home)"
function md() { mkdir "$1" && cd "$1" }
function o() { xdg-open $1 &> /dev/null &}

# Package Management Aliases
alias up="sudo pacman -Syu --noconfirm && flatpak update -y"
alias fpi="flatpak remote-ls --app --columns=application | fzf -m | xargs -ro flatpak install"
alias fpr="flatpak list --app --columns=application | fzf --multi | xargs -ro flatpak remove --delete-data"
alias pi='pacman -Slq | fzf --multi --preview "pacman -Si {1}" | xargs -ro sudo pacman -S'
alias pr='pacman -Qq | fzf --multi --preview "pacman -Qi {1}" | xargs -ro sudo pacman -Rns'

# git aliases
alias gs="git status --short"
alias ga="git add"
alias gaa="git add --all"
alias gc="git commit --message"
alias gca="git commit --all --message"
alias gsw="git switch"
alias gcb="git switch --create"
alias gd="git diff"
alias gl="git log --graph --decorate --oneline"
alias gp="git pull"
alias gP="git push"
alias gre="git reset --hard HEAD"

# Bind arrow keys to search history based on the typed command prefix.
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search
bindkey "^[[B" down-line-or-beginning-search

# function auto_ls() {
#     ls -lhF --time-style=long-iso --color=auto
# }
# chpwd_functions+=(auto_ls)


# Added by Antigravity CLI installer
export PATH="/home/born/.local/bin:$PATH"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
