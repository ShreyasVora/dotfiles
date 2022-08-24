#########################################
# Contains all quick aliases I have set
#########################################

#alias vfix='vim $RELEASE/data/procMan.fiuk_prices'
alias virt='vim $RELEASE/data/procMan.virt'
#alias vcan='vim $RELEASE/data/procMan.can'
alias hist='cat /home/svora/bash/.bash_history | grep -i'
alias vi='vim'
alias grep='grep --color=auto'
alias cpmp='ctrl_procman -me -preview'
alias cpp='ctrl_procman -preview'
alias cpmr='ctrl_procman -me -read'
alias cpr='ctrl_procman -read'
alias hive='/oracle_client/product/11.2.0/sqldeveloper/sqldeveloper.sh'
alias hvie='/oracle_client/product/11.2.0/sqldeveloper/sqldeveloper.sh'
alias hivecheck='python3 /home/svora/support/tools/hive_check.py'
alias hivecheckdo='python3 /home/svora/support/tools/hive_check.py -do'
alias hivecheckdone='python3 /home/svora/support/tools/hive_check.py -done'
alias hivecheckdd='python3 /home/svora/support/tools/hive_check.py -do; python3 /home/svora/support/tools/hive_check.py -done'
alias 52nd='sim_env 52nd'
alias vt_logs='for host in `procflat -p vt | cut -d" " -f2 | sort -u`; do ssh $host "/bin/ls -FlAtr /local/data/hosts/$host/vtServer*"; done'
alias wai='/srg/pro/data/config/whereAmI'
alias d='xauth list | grep `hostname` | sed "s/^/xauth add /g"; echo export DISPLAY=$DISPLAY'
alias slack="slack -e --proxy-server=prism:2868 & "
alias chrome='chromium-browser --proxy-server=prism:2868 &'
alias chromium-browser='chromium-browser --proxy-server=prism:2868 &'
alias gl='git log --name-status --no-merges'
alias glt='git log --graph --decorate --oneline $(git rev-list -g --all)'
alias gc='git commit'
alias grepcsv='cd /home/svora/nodes/makoCode; /srg/pro/release/current/scr/grepc -node /home/svora/nodes/makoCode'
alias ssh='ssh -X'
alias scsh='import screenshot.png'
alias c='clear'
alias capacity_planning='python3 ~/support/tools/capacity_planning.py -config ~/support/tools/capacity_planning.json -network'
alias ltoday='ls -FlAtr *$(h2e -t)*'
alias pyCharm='/snap/pycharm-community/current/bin/pycharm.sh'
alias fixkh='ssh-keygen -R'
alias central_dist='supro /srg/pro/data/support/tools/support_central_config_dist.sh -net'
alias gcmp='git checkout master && git pull'
alias build_port_checker='go build -o go_bin/ tools/go_projects/port_checker/port_checker.go'
alias riah='/home/svora/scripts/run_in_all_hosts.sh'
