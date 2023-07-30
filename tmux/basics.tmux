# ===============================
# Basic settings
# ===============================

# Set default scripting language
set-option -g default-shell /bin/bash
# This would then mean any run-shell bind would execute in bash. See below example where we only pane switch up if it exists
# bind Up run-shell "if [ $(tmux display-message -p '#{pane_at_top}') -ne 1 ]; then tmux select-pane -U; fi"

# Allow mouse selection of panes. set -g (ie global) enables this setting when new tmux session launched, not just when resourced
set -g mouse on
set -g focus-events on

# remap prefix from Ctrl-b to `. Ensure there's still a way to type `, by double clicking
unbind C-b
set -g prefix `
bind-key ` send-prefix

# reload tmux config with r
bind r source-file ~/.tmux.conf
