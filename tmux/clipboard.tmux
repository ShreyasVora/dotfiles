# ===============================
# Copy mode and clipboard config
# ===============================

# Set copy-mode highlighting colour
set -g mode-style 'bg=#5fff00,fg=#5f0087'

# Define word seperators
set -g word-separators "<>(){}[]'\";@*+,=!£$%^&:#~?`¬|\\ "

bind v copy-mode                                                                              # Enter copy-mode
bind p run-shell "xclip -sel c -o | tmux load-buffer - && tmux paste-buffer"                  # Get current system clipboard and load this into tmux buffer. Then paste it
bind -n MouseDown2Pane run-shell "xclip -sel c -o | tmux load-buffer - && tmux paste-buffer"  # Can also use middle mouse for this
bind -T copy-mode-vi Escape send -X cancel                                                    # Clear selection and exit copy mode
bind -T copy-mode-vi q send -X clear-selection                                                # Clear selection but stay in copy mode
bind -T copy-mode-vi v send -X begin-selection                                                # Begin selection
bind -T copy-mode-vi Space send -X rectangle-toggle                                           # Toggle rectangle vs linewise
bind -T copy-mode-vi Enter send -X copy-pipe-and-cancel "xclip -i -sel c"                     # Copy selection to clipboard

# Mouse drag copy settings
# These need to go at the bottom of the file due to the overrides in the plugin I guess

# Binds to cancel copy mode highlighted stuff with mouse to match q and Esc behaviour
bind -T copy-mode-vi MouseDown2Pane select-pane \; send-keys -X copy-pipe-and-cancel "xclip -i -sel c" \; paste-buffer
bind -T copy-mode-vi MouseDown3Pane select-pane \; send-keys -X copy-pipe-and-cancel "xclip -i -sel c"

# Double LMB to select a word
bind -T copy-mode-vi DoubleClick1Pane select-pane \; send-keys -X select-word-no-clear \; send-keys -X copy-pipe-no-clear "xclip -in -sel c"
bind -n DoubleClick1Pane select-pane \; copy-mode -M \; send-keys -X select-word \; send-keys -X copy-pipe-no-clear "xclip -in -sel c"

# Triple LMB Select & Copy (Line)
bind -T copy-mode-vi TripleClick1Pane select-pane \; send-keys -X select-line \; send-keys -X copy-pipe-no-clear "xclip -in -sel c"
bind -n TripleClick1Pane select-pane \; copy-mode -M \; send-keys -X select-line \; send-keys -X copy-pipe-no-clear "xclip -in -sel c"

# Disables pane switching with the escape key and sets the escape key delay to 0
set -s escape-time 0
