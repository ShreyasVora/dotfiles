# ===============================
# TMUX Other mappings
# ===============================

# == Window management ==
bind , command-prompt "rename-window '%%'"              # Rename window (This is the existing bind, except I have modified it so current window name does not show up in prompt)
unbind c                                                # Get rid of old bind
# The command below will:
# - create a new window
# - prompt you for a name
# - potentially run something in the window after the window has been created, based on the first word in the window name
bind t command-prompt -p "New window: " "new-window -n '%%' '/home/svora/scripts/tmux/tmux-new-window %1'"
# The command below will:
# - Open popup window with tmux session scratch if popup not already in existence
# - Detach from this session if it is open, effectively minimising the popup
bind -n C-Space if-shell -F '#{==:#{session_name},scratch}' { detach-client } { popup -w 70% -h 70% -E "tmux new-session -A -s scratch"}   # Display popup
bind -n C-t new-window                                  # Quickly open new window without naming
bind q killp                                            # Kill pane without confirmation
bind w confirm-before -p "kill-window #W? (y/n)" killw  # Kill window, but confirm first
