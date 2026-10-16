# Auto-start tmux
[[ -o interactive && -z "$TMUX" ]] && exec tmux new -A -s main

# Load direnv env before instant prompt so its "loading .envrc" output doesn't trigger p10k's console-output warning.
[[ ! -e /etc/NIXOS ]] && (( ${+commands[direnv]} )) && emulate zsh -c "$(direnv export zsh)"

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Completion
zmodload zsh/complist
autoload -Uz compinit && compinit -d ~/.config/.zcompdump
setopt complete_in_word     # complete from the cursor position, not only at word end
setopt always_to_end        # move cursor past the completed word
setopt auto_menu            # second Tab starts the menu
setopt list_packed          # denser candidate list
unsetopt menu_complete      # first Tab only inserts the common prefix
zstyle ':completion:*' menu select
# lowercase also matches uppercase (not vice versa); falls back to partial-word (foo-b<Tab> -> foo-bar), then substring (cde<Tab> -> abcdef)
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' '+r:|[._-]=* r:|=*' '+l:|=* r:|=*'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:messages' format '%F{purple}-- %d --%f'
zstyle ':completion:*:warnings' format '%F{red}-- no matches --%f'
zstyle ':completion:*' squeeze-slashes true
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.cache/zsh/compcache
_comp_options+=(globdots)   # include dotfiles without typing the leading dot
bindkey -M menuselect '^[[Z' reverse-menu-complete   # Shift+Tab goes back
bindkey -M menuselect '^[' send-break                 # Esc cancels the menu

# History options
setopt no_case_glob
setopt share_history
setopt hist_ignore_all_dups

# Plugins (on NixOS these are loaded by programs.zsh in nixos/modules/system.nix)
[[ -r ~/.local/share/powerlevel10k/powerlevel10k.zsh-theme ]] && source ~/.local/share/powerlevel10k/powerlevel10k.zsh-theme
[[ -r /usr/share/doc/fzf/examples/key-bindings.zsh ]] && source /usr/share/doc/fzf/examples/key-bindings.zsh
[[ -r /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]] && source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
[[ ! -e /etc/NIXOS ]] && (( $+commands[zoxide] )) && eval "$(zoxide init zsh)"
[[ ! -e /etc/NIXOS ]] && (( ${+commands[direnv]} )) && emulate zsh -c "$(direnv hook zsh)"

# fzf-zoxide integration
function fzf_zoxide() { 
    LBUFFER+=$(zoxide query --list | fzf --reverse --height=40%)
    zle reset-prompt
}
zle -N fzf_zoxide

# Keybindings
bindkey -e
WORDCHARS='*?_[]~'   # stop word motions/kills at / . - = and shell syntax, e.g. one path component per Ctrl+Backspace
bindkey '^o' fzf_zoxide
bindkey -r '\ec'            # fzf cd widget: Alt+C is taken by tmux
bindkey '^g' fzf-cd-widget    # Ctrl+G: go to directory
bindkey "^H" backward-kill-word
bindkey "^[[3;5~" kill-word
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word
bindkey "^[[3~" delete-char
# Home/End: sequences differ between xterm (^[[H), application cursor mode (^[OH) and tmux/rxvt (^[[1~).
for key in "^[[H" "^[OH" "^[[1~" "^[[7~" "${terminfo[khome]}"; do [[ -n $key ]] && bindkey "$key" beginning-of-line; done
for key in "^[[F" "^[OF" "^[[4~" "^[[8~" "${terminfo[kend]}"; do [[ -n $key ]] && bindkey "$key" end-of-line; done
unset key

# Useful Aliases
alias n="nvim"
alias nd="nvim +\"DiffviewOpen --imply-local\""
alias c="claude"
alias cc="claude --continue"
alias cr="claude --resume"
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
alias tree="eza --tree --all --git-ignore --ignore-glob=.git --group-directories-first"
alias tree2="tree --level=2"
alias tree3="tree --level=3"
alias tree4="tree --level=4"
alias venv="source venv/bin/activate || python -m venv venv && source venv/bin/activate"
function md() { mkdir -p "$1" && cd "$1" }
function o() { xdg-open $1 &> /dev/null &}
function apti() { apt-cache pkgnames | fzf -m --height=10 --reverse | xargs -r sudo apt install -y }

# git aliases
alias grh="git reset"
alias grhh="git reset --hard"
alias gundo="git reset HEAD~1"
alias grsm="git fetch origin main && git restore --source origin/main"
alias gf="git fetch --prune --all"
alias gs="git status --short"
alias ga="git add"
alias gaa="git add --all"
alias gc="git commit"
alias gca="git commit --amend --no-edit"
alias gcm="git commit --message"
alias gcam="git commit --all --message"
alias gm="git merge"
alias gma="git merge --abort"
alias gmc="git merge --continue"
alias gsw="git switch"
alias gswc="git switch --create"
alias gd="git diff"
alias glog="git -c log.graphColors=brightblack log --graph -10 --date=short --pretty=format:'%C(blue)%h%C(reset) %C(dim)%ad%C(reset) %s %C(dim)(%an)%C(reset)%C(auto)%d%C(reset)'"
alias gl="git pull"
alias glm="git pull origin main"
alias gp="git push"
alias gstu="git stash --include-untracked"
alias gstp="git stash pop"
alias gwipe="git reset --hard HEAD && git clean -fd"
alias gnuke="git reset --hard HEAD && git clean -ffdx && git submodule foreach --recursive 'git reset --hard HEAD && git clean -ffdx' && git submodule update --init --recursive --force"
alias gwip='git add -A; git rm $(git ls-files --deleted) 2> /dev/null; git commit --no-verify --no-gpg-sign --message "--wip-- [skip ci]"'
alias gunwip='git rev-list --max-count=1 --format="%s" HEAD | grep -q -- "--wip--" && git reset HEAD~1'
function gwt() {
  local b=change-${1#change-}
  git fetch -q --no-tags origin "+refs/heads/$b:refs/remotes/origin/$b" 2>/dev/null
  git worktree add --guess-remote ~/$b && cd ~/$b
}
function prune-worktrees() {
  local d
  for d in ~/*(/N); do
    [[ -f $d/.git ]] || continue
    git -C $d fetch -q origin main &&
    git -C $d merge-base --is-ancestor HEAD origin/main &&
    git -C $d worktree remove --force $d && echo "removed $d"
  done
}

# Bind arrow keys to search history based on the typed command prefix.
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
# Terminals in application cursor mode (e.g. inside tmux) send ^[OA/^[OB instead of ^[[A/^[[B.
for key in "^[[A" "^[OA" "${terminfo[kcuu1]}"; do [[ -n $key ]] && bindkey "$key" up-line-or-beginning-search; done
for key in "^[[B" "^[OB" "${terminfo[kcud1]}"; do [[ -n $key ]] && bindkey "$key" down-line-or-beginning-search; done
unset key

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Bypass the Zscaler proxy for the Bazel Central Registry. Through the proxy,
# Bazel's registry fetches fail with "Unable to tunnel through proxy. Proxy
# returns HTTP/1.0 502 Bad Gateway", even though curl through the same proxy
# works. A Bazel server keeps the proxy env it started with, so run
# `bazel shutdown` in each worktree after changing this.
#
# To check whether this is still needed, run this from a Fenix worktree. It
# starts a throwaway Bazel server with empty caches and the proxy in use, and
# leaves the real caches alone:
#   env -u no_proxy -u NO_PROXY bazel --output_base="$(mktemp -d)" \
#       mod deps --repository_cache="$(mktemp -d)"
# If it succeeds, the proxy no longer blocks Bazel and this can be removed.
export no_proxy="bcr.bazel.build${no_proxy:+,$no_proxy}" NO_PROXY="bcr.bazel.build${NO_PROXY:+,$NO_PROXY}"

# Must be sourced last
[[ -r /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] && source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
