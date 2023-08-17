# ===============================
# TMUX motions
# ===============================

# == Creating new panes ==
bind Right split-window -h
bind Left split-window -h\; swap-pane -U
bind Down split-window -v
bind Up split-window -v\; swap-pane -U
bind S-Right split-window -hf
bind S-Down split-window -vf
# Unbind defaults
unbind '"'
unbind %

# == Navigating around panes ==
is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
    | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|l?n?vim?x?)(diff)?$'"
bind-key -n 'M-Left' if-shell "$is_vim" 'send-keys M-Left'  'select-pane -L'
bind-key -n 'M-Down' if-shell "$is_vim" 'send-keys M-Down'  'select-pane -D'
bind-key -n 'M-Up' if-shell "$is_vim" 'send-keys M-Up'  'select-pane -U'
bind-key -n 'M-Right' if-shell "$is_vim" 'send-keys M-Right'  'select-pane -R'
bind-key -T copy-mode-vi -n 'M-Left' if-shell "$is_vim" 'send-keys M-Left'  'select-pane -L'
bind-key -T copy-mode-vi -n 'M-Down' if-shell "$is_vim" 'send-keys M-Down'  'select-pane -D'
bind-key -T copy-mode-vi -n 'M-Up' if-shell "$is_vim" 'send-keys M-Up'  'select-pane -U'
bind-key -T copy-mode-vi -n 'M-Right' if-shell "$is_vim" 'send-keys M-Right'  'select-pane -R'
bind-key -n 'M-h' if-shell "$is_vim" 'send-keys M-Left'  'select-pane -L'
bind-key -n 'M-j' if-shell "$is_vim" 'send-keys M-Down'  'select-pane -D'
bind-key -n 'M-k' if-shell "$is_vim" 'send-keys M-Up'  'select-pane -U'
bind-key -n 'M-l' if-shell "$is_vim" 'send-keys M-Right'  'select-pane -R'
bind-key -T copy-mode-vi -n 'M-h' if-shell "$is_vim" 'send-keys M-Left'  'select-pane -L'
bind-key -T copy-mode-vi -n 'M-j' if-shell "$is_vim" 'send-keys M-Down'  'select-pane -D'
bind-key -T copy-mode-vi -n 'M-k' if-shell "$is_vim" 'send-keys M-Up'  'select-pane -U'
bind-key -T copy-mode-vi -n 'M-l' if-shell "$is_vim" 'send-keys M-Right'  'select-pane -R'

# == Moving panes around ==
bind l display-panes                        # Display pane numbers of each pane currently visible
bind < swap-pane -U                         # Swap current pane with the one behind it in the order
bind > swap-pane -D                         # Swap current pane with the one after it in the order
bind b break-pane                           # "break" this pane, ie move it into it's own new window
bind j join-pane                            # "join" currently marked pane to the current one (mark pane with rmb / hot+m)

# == Moving around windows ==
bind -n M-PgUp swap-window -t -1            # Move current window to window number n-1
bind -n M-PgDn swap-window -t +1            # Move current window to window number n+1
bind -n C-S-Left previous-window            # Change focus to window number n-1
bind -n C-S-Right next-window               # Change focus to window number n+1
bind Tab last-window                        # Move to last active window
# The same, but for copy mode
bind -T copy-mode-vi -n M-PgDn swap-window -t +1
bind -T copy-mode-vi -n M-PgUp swap-window -t -1
bind -T copy-mode-vi -n C-S-Left previous-window
bind -T copy-mode-vi -n C-S-Right next-window
bind -T copy-mode-vi Tab last-window

# == Zoom pane ==
bind z resize-pane -Z
bind [ resize-pane -Z\; resize-pane -t .-1 -Z\; display-panes
bind ] resize-pane -Z\; resize-pane -t .+1 -Z\; display-panes

# == Resize panes ==
# Note, C-arrows are bound to resize pane by 1 by default. These binds allow larger increments.
bind M-Up resize-pane -U 20
bind M-Down resize-pane -D 20
bind M-Left resize-pane -L 20
bind M-Right resize-pane -R 20

# == Quicker movement in copy mode ==
bind -T copy-mode-vi C-Left send -X previous-word
bind -T copy-mode-vi C-Right send -X next-word
bind -T copy-mode-vi Home send -X start-of-line
bind -T copy-mode-vi End  send -X end-of-line
bind -T copy-mode-vi C-Down send -X next-paragraph
bind -T copy-mode-vi C-Up send -X previous-paragraph
bind -T copy-mode-vi C-Home send -X history-top
bind -T copy-mode-vi C-End send -X history-bottom
