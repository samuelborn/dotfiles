# Every terminal starts in tmux. -t 1 skips non-terminal shells (scripts, Claude Code), the tmux check a machine not yet rebuilt.
[[ -z $TMUX && -t 1 ]] && (( $+commands[tmux] )) && exec tmux

# Load direnv env before instant prompt so its "loading .envrc" output doesn't trigger p10k's console-output warning.
emulate zsh -c "$(direnv export zsh)"

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Machine-specific, unmanaged: Zscaler cert vars, secrets.
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

# Prompt and plugins (sourced at the end) are installed by nix/common.nix
source /run/current-system/sw/share/zsh-powerlevel10k/powerlevel10k.zsh-theme

# History
HISTFILE="${XDG_STATE_HOME:-$HOME/.local/state}/zsh/history"
HISTSIZE=100000
SAVEHIST=100000
mkdir -p "${HISTFILE:h}"
setopt share_history
setopt hist_ignore_all_dups
setopt hist_ignore_space

# Completion
zmodload zsh/complist   # menuselect keymap for the binds below
autoload -Uz compinit && compinit -d "${XDG_CACHE_HOME:-$HOME/.cache}/zcompdump"
setopt no_case_glob
setopt interactive_comments
setopt complete_in_word   
setopt list_packed        
_comp_options+=(globdots)   
zstyle ':completion:*' menu select   
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' '+l:|=* r:|=*'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/compcache"

bindkey -e
bindkey -M menuselect '^[[Z' reverse-menu-complete   # Shift+Tab goes back
bindkey -M menuselect '^[' send-break                 # Esc cancels the menu

# fzf keys (Ctrl+T, Ctrl+R, Ctrl+G below), zoxide as cd, direnv
source <(fzf --zsh)
eval "$(zoxide init zsh --cmd cd)"
eval "$(direnv hook zsh)"

# Ctrl+O: jump to a zoxide directory via fzf
function fzf_zoxide() {
  local dir=$(zoxide query --list | fzf --reverse --height=40%)
  if [[ -n $dir ]]; then
    cd "$dir"
    # A widget doesn't redraw the prompt on its own, so p10k would keep showing the old directory.
    local hook
    for hook in $precmd_functions; do $hook; done
  fi
  zle reset-prompt
}
zle -N fzf_zoxide

# Ctrl+Z at the prompt resumes the last suspended job
function fg_widget() {
  (( $#jobstates )) || return
  zle push-input
  BUFFER=fg
  zle accept-line
}
zle -N fg_widget

# Keybindings
WORDCHARS='*?_[]~'   
bindkey '^o' fzf_zoxide
bindkey '^z' fg_widget
bindkey "^H" backward-kill-word
bindkey "^[[3;5~" kill-word
bindkey "^[[1;3C" forward-word   # Alt+Right
bindkey "^[[1;3D" backward-word  # Alt+Left
bindkey "^[[3~" delete-char
bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line

# Up/Down search history by the typed prefix.
autoload -U up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
for key in "^[[A" "^[OA"; do bindkey "$key" up-line-or-beginning-search; done
for key in "^[[B" "^[OB"; do bindkey "$key" down-line-or-beginning-search; done
unset key

# Aliases
alias n="nvim"
alias nd="nvim +\"DiffviewOpen --imply-local\""
alias c="claude"
alias cc="claude --continue"
alias cr="claude --resume"
alias g="lazygit"
if [[ $OSTYPE == darwin* ]]; then
  # macOS trash moves to ~/.Trash but rejects rm flags like -rf, so drop them
  rm() { /usr/bin/trash "${@:#-*}" }
else
  alias rm="trash"
fi
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
alias venv="[[ -f venv/bin/activate ]] || python -m venv venv && source venv/bin/activate"
function md() { mkdir -p "$1" && cd "$1" }
function nr() { NIXPKGS_ALLOW_UNFREE=1 nix run --impure nixpkgs#"$1" -- "${@:2}" }

# git aliases
alias grh="git reset"
alias grhh="git reset --hard"
alias gundo="git reset HEAD~1"
alias grsm="git restore --source origin/main"
alias gcl="git clone --recurse-submodules"
alias gf="git fetch --all"
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
alias gwip='git add -A; git commit --no-verify --no-gpg-sign --message "--wip-- [skip ci]"'
alias gunwip='git log -1 --format=%s | grep -q -- --wip-- && git reset HEAD~1'

# Worktree per change branch: gwt 123 -> ~/change-123
function gwt() {
  local b=change-${1#change-}
  git fetch -q --no-tags origin "+refs/heads/$b:refs/remotes/origin/$b" 2>/dev/null
  git worktree add --guess-remote ~/$b &&
  git -C ~/$b submodule update --init --recursive &&
  { [[ ! -f ~/$b/.envrc ]] || direnv allow ~/$b } &&
  cd ~/$b
}
function gwtr() {
  local d
  for d in ~/*(/N); do
    [[ -f $d/.git ]] || continue
    git -C $d fetch -q origin main &&
    git -C $d merge-base --is-ancestor HEAD origin/main &&
    git -C $d worktree remove --force $d && echo "removed $d"
  done
}

if [[ $OSTYPE == darwin* ]]; then
  function o() { open "${@:-.}" }
else
  function o() { xdg-open "${1:-.}" &> /dev/null & }
fi

source ~/.p10k.zsh
source /run/current-system/sw/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /run/current-system/sw/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
