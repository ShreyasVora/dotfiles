# ===============================
# TMUX display options
# ===============================

# == Status bar ==
set -g status-position bottom                                      # Status bar at the bottom of the screen rather than the top
set -g status-interval 2                                           # Rewrite status bar every 2 seconds - no need for it to be more frequent
set -g status-right-length 100                                     # Increase right pane of status bar character limit to 100
set -g status-left-length 100                                      # Increase left pane character limit to 100
set -g status-style 'fg=#ffffff,bg=#004040'                        # Set status bar colour (bg) and default text colour (fg)
set -g @plugin 'soyuka/tmux-current-pane-hostname              '   # Install plugin to be able to get hostname of current host. This stores it as #H, which will be used later.
setw -g window-status-current-style 'fg=#660066,bg=#00cc00'        # Chosen window has different format in status bar
setw -g window-status-style 'bg=#121212,fg=#606060'                # Colour scheme for other (currently inactive) windows
set -g renumber-windows on                                         # This allows automatic renumbering, so if you delete window 2, it will move mindows 3,4,etc down a number
# Status bar text
set -g status-right '#{?client_prefix,#[bg=#800000] H #[default],#[bg=#121212,fg=#606060] H #[default]}#{?window_zoomed_flag,#[bg=#800000] Z #[default],#[bg=#121212,fg=#606060] Z #[default]} #[fg=#ffff00]|#[default] #[bg=#000099] %a %e %b %Y %H:%M #[default]'
set -g status-left '#[bg=#660000][#{session_name}]#[default] #[bg=#664d00][#H]#[default] '

# == Pane display settings / colours ==
set -g pane-border-status top                                      # Set pane header to be at the top of the pane
setw -g automatic-rename off                                       # Set window naming to not be automatic
set -g pane-border-format '#P'                                     # Set pane title to just be #P (pane_id)
set -g pane-active-border-style 'fg=#00ff00,bg=#444444'            # For current active pane, have special border format to highlight it
set -g pane-border-style 'fg=#606060'                              # Dull colours for inactive pane
set -g window-active-style 'bg=#0f0f0f'                            # Slightly highlighted background for active pane

# == Misc ==
set -g base-index 1                                                # Start numbering windows at 1, not 0.
set -g pane-base-index 1                                           # Start numbering panes at 1, not 0.
set -g history-limit 50000                                         # Set large scroll limit for each tmux pane

