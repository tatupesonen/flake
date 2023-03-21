# Setup fzf
# ---------
if [[ ! "$PATH" == */home/tatu/.fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/home/tatu/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/home/tatu/.fzf/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
source "/home/tatu/.fzf/shell/key-bindings.zsh"
