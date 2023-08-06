#########################################
# Contains all quick aliases I have set
#########################################

# Basic bash aliases
alias hist='cat /home/svora/dotfiles/.bash_history | grep -i'
alias vi='vim'
alias gvi='gvim -geometry +200+200'
alias gvim='gvim -geometry 250x60+100+100'
alias grep='grep --color=auto'
alias lessg='less +G'
alias lessf='less +F'
alias ssh='ssh -X'
alias isol='cores=$(cat /sys/devices/system/cpu/isolated); [[ -n $cores ]] && echo $cores || echo "No isolated cores on $HOST"'
alias -- -="cd -"
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

# Vi procMan files
alias virt='vim $RELEASE/data/procMan.virt'
alias vspark='vim $RELEASE/data/procMan.spark'

# ctrl_procman shortcuts
alias cpmp='ctrl_procman -me -preview'
alias cpp='ctrl_procman -preview'
alias cpmr='ctrl_procman -me -read'
alias cpr='ctrl_procman -read'
alias cpmpg='ctrl_procman -me -preview -f procMan.globex'
alias cppg='ctrl_procman -preview -f procMan.globex'
alias cpmrg='ctrl_procman -me -read -f procMan.globex'
alias cprg='ctrl_procman -read -f procMan.globex'
alias cpmps='ctrl_procman -me -preview -f procMan.spark'
alias cpps='ctrl_procman -preview -f procMan.spark'
alias cpmrs='ctrl_procman -me -read -f procMan.spark'
alias cprs='ctrl_procman -read -f procMan.spark'

# Other useful support aliases
alias pf='/home/svora/scripts/procflatAdj'
alias procc='proc -cd'  # My proc function does not cd by default
alias d='xauth list | grep `hostname` | tail -n 1 | sed "s/^/xauth add /g"; echo export DISPLAY=$DISPLAY'  # To echo the information that would be needed to set display properly
alias lt='ls -FlAtr --color=auto'
alias ltoday='ls -FlAtr *$(h2e -t)*'
alias wai='/srg/pro/data/config/whereAmI'

# Support repo scripts
alias capacity_planning='python3 ~/support/tools/capacity_planning.py -config ~/support/tools/capacity_planning.json -network'
alias c-dist='supro /srg/pro/data/support/tools/support_central_config_dist.sh -net'
alias c-dist.='supro /srg/pro/data/support/tools/support_central_config_dist.sh -net $(pwd | awk -F/ "{print \$NF}")'
alias c-logs='lt ../../logs/$(pwd | rev | cut -d/ -f1 | rev)* | tail | sed "s:../../logs/::g"'
alias c-tests='cd /srg/dev/release/prod-config/tests'
alias cgrep='grep --exclude-dir=.git --exclude=\*.patch --exclude-dir=unused -r'

# Git shortcuts
alias gl='git --no-pager lol --name-status -5'
alias glt='git log --graph --decorate --oneline $(git rev-list -g --all)'
alias gc='git commit'
alias ga='git add .'
alias gr='git restore .'
alias gu='git unstage .'
alias gd='git diff'
alias gds='git diff --staged'
alias gg='clear; git status; git --no-pager diff; git add .; git status'
alias gcmp='git checkout master && git pull'

# SVORA stuff
alias grepcsv='cd ~/nodes/makoCode; /srg/pro/release/current/scr/grepc -node ~/nodes/makoCode'
alias riah='~/scripts/run_in_all_hosts.sh'
alias riahp='~/scripts/run_in_all_hosts.sh -prod'
alias ccode='cd ~/nodes/makoCode'
alias cd.='cd ~/dotfiles'
alias xset_reset_mouse='xset mouse 2 4'
alias cheat='glow ~/scripts/docs/ --config ~/dotfiles/.glow.yml'
alias glow='glow --config ~/dotfiles/.glow.yml'
