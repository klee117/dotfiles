[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# tldr --update is broken in 1.6.1 (tldr.sh uses JS redirect); download directly
tldr-update() {
  local cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}/tealdeer/tldr-pages"
  local zip_url="https://github.com/tldr-pages/tldr/releases/latest/download/tldr.zip"
  local tmp_zip
  tmp_zip=$(mktemp /tmp/tldr-XXXXXX.zip)
  echo "Downloading tldr pages from GitHub..."
  curl -fsSL "$zip_url" -o "$tmp_zip" || { echo "Download failed"; rm -f "$tmp_zip"; return 1; }
  mkdir -p "$cache_dir"
  unzip -oq "$tmp_zip" -d "$cache_dir" && echo "tldr cache updated." || echo "Extract failed."
  rm -f "$tmp_zip"
}

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# tmux 3claw profile
alias dev='tmux-profile 3claw'
alias cdx='tmux-profile codex'
