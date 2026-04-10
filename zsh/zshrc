if [[ -s "$HOME/.zprezto/init.zsh" ]]; then
  # Disable prezto's themed prompt so we can keep a custom path-only prompt.
  zstyle ':prezto:module:prompt' theme 'off'
  source "$HOME/.zprezto/init.zsh"
fi

# Show only the last 3 path segments, no git info.
PROMPT='%~ %B%F{blue}\$%f%b '
RPROMPT=''

alias n="nvim12 -u /Users/vahagn/Other/Nvim12/init.lua"
alias nc="n /Users/vahagn/Other/Nvim12/init.lua"
alias vi="nvim"
alias vim="nvim"

export EDITOR="nvim"
export VISUAL="nvim"

# bun completions
[ -s "/Users/vahagn/.bun/_bun" ] && source "/Users/vahagn/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
export PATH="/Users/vahagn/.bun/bin:$PATH"
export PATH="/Users/vahagn/Other/Nvim12/bin/:$PATH"

# Vite+ bin (https://viteplus.dev)
. "$HOME/.vite-plus/env"
export PATH="$HOME/.local/bin:$PATH"
