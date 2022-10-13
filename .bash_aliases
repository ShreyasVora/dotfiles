#########################################
# Contains all quick aliases I have set
#########################################

# Basic bash aliases
alias hist='cat /home/svora/bash/.bash_history | grep -i'
alias vi='vim'
alias grep='grep --color=auto'

# Vi procMan files
alias virt='vim $RELEASE/data/procMan.virt'

# ctrl_procman shortcuts
alias cpmp='ctrl_procman -me -preview'
alias cpp='ctrl_procman -preview'
alias cpmr='ctrl_procman -me -read'
alias cpr='ctrl_procman -read'
alias ssh='ssh -X'
alias c='clear'
alias t='tmux'

# Other useful support aliases
alias pf='/home/svora/scripts/procflatAdj'
alias procc='proc -cd'
alias d='xauth list | grep `hostname` | tail -n 1 | sed "s/^/xauth add /g"; echo export DISPLAY=$DISPLAY'
alias ltoday='ls -FlAtr *$(h2e -t)*'
alias wai='/srg/pro/data/config/whereAmI'
alias hivecheck='python3 /home/svora/support/tools/hive_check.py'

# Support repo scripts
alias build_port_checker='go build -o go_bin/ tools/go_projects/port_checker/port_checker.go'
alias capacity_planning='python3 ~/support/tools/capacity_planning.py -config ~/support/tools/capacity_planning.json -network'
alias central_dist='supro /srg/pro/data/support/tools/support_central_config_dist.sh -net'

# Git shortcuts
alias gl='git lol --name-status -10'
alias gc='git commit'
alias ga='git add .'
alias gd='git diff'
alias gds='git diff --staged'
alias gcmp='git checkout master && git pull'

# SVORA stuff
alias grepcsv='cd /home/svora/nodes/makoCode; /srg/pro/release/current/scr/grepc -node /home/svora/nodes/makoCode'
alias riah='/home/svora/scripts/run_in_all_hosts.sh'
