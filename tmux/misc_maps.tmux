# ===============================
# TMUX Other mappings
# ===============================

# == Window management ==
bind , command-prompt "rename-window '%%'"              # Rename window (This is the existing bind, except I have modified it so current window name does not show up in prompt)
bind -n C-t new-window -n 'quick'                       # Create new window quickly (no need to choose a name)
unbind c                                                # Get rid of old bind
# The command below will:
# - create a new window
# - prompt you for a name
# - potentially run something in the window after the window has been created, based on the first word in the window name
bind t command-prompt -p "New window: " "new-window -n '%%' '/home/svora/scripts/tmux/tmux-new-window %1'"
bind q killp                                            # Kill pane without confirmation
bind w confirm-before -p "kill-window #W? (y/n)" killw  # Kill window, but confirm first
