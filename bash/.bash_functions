#!/bin/bash
##############################################
# This file contains all of my bash functions
# This includes small ones for faster cd-ing, as well as bigger ones such as proc or svr
# ############################################

echo """
What functions do I have here?

==== LOGS ====
llog - less a log file by either giving it a PID or the log file name, no matter which directory you're in. Accepts gzipped files, and you can give it extra args to grep the log
proc - filter logs based on process and command line args and display them in nice table format

==== HOSTS ====
hwshosts    - cat the hwshosts file and search it
globalhosts - similar to above

==== NAVIGATION ====
cd       - replaces standard cd with fuzzy option
cdh      - standard cd so we still have the option to cd to home dir
cdv      - cd /srg/pro/data/var and subdirs
cde      - cd /srg/pro/data/etc and subdirs
cda      - cd /srg/pro/data and subdirs
cdr      - cd /srg/pro/release and subdirs
cdev     - cd /srg/pro/data/etc/vt
cd(e|v)o - cd to corresponding dir for options/derivatives on this given network
cd(e|v)s - cd to corresponding dir for stocks on this given network
gou      - goto -user ...
gout     - same as gou, but with tmux pane split
gop      - goto -net . -p . -f .
tgb      - tmux go to box. ssh's to the current window name

==== ISSUES ====
cdi - cd to specified issues dir
mki - make specified issues dir
lti - lt specified issues dir
cpi - cp a file to a specified issues dir

==== MISC ====
loop_central   - loop through central config dirs and run commands in all
svr            - script to comment out or uncomment processes in procman in big batches
flip_links_me  - a way to run flip_links as pro with an alias of my own. Think it's broken though
ms             - make script (copy from by bash_template script)
crons          - list all user crons on this box, or a particular user's cron
clean          - clean up current working directory of any file older than a day old. Useful for /var/core
vwhich         - vi a file that isn't in pwd but is in path
vscp           - vi a file over ssh connection
svscst         - become pro and add /home/svora/scripts/strippedStackDump to tmux buffer
devpush        - sync a file over to dev
devpull        - sync a file over from dev
mkpatch        - commit currently staged changes in a git repo, turn it into a patch, delete the temp branch

==== FZF ====
pff      - procflat searcher using fzf
pfg      - procflat searcher using fzf, then ssh to chosen process host
fzg      - use fzf to grep -r for a string from current dir and show results in preview window
""" > /dev/null


function llog() {
	if [ -d /local/data/hosts/$SECOND/$HOST ]; then
		parent_dir=/local/data/hosts/$SECOND/$HOST
	else
		parent_dir=$RUNTIME_DATA/data/hosts/$HOST
	fi
	pid=$1
	sta=
	cins=
	excl=
	err=
	file=
	lessflg=
	debug=
	selection=
	mode=llog_cat
	shift
	while [[ $# -gt 0 ]]; do
		case "$1" in
			-i)
				shift
				cins+="(?=.*$1)"
				;;
			-v)
				shift
				excl+="|$1"
				;;
			+F)
				lessflg='+F'
				;;
			+G)
				lessflg='+G'
				;;
			-t)
				mode=llog_tail
				;;
			-d)
				debug=true
				;;
			-help)
				err=true
				;;
			*)
				sta+="(?=.*$1)"
				;;
		esac
		shift
	done

	if [[ -n $err ]] || [[ $pid = '-help' ]]; then
		cat << EOF
Usage:  llog [ log name / PID ] [ grep args ]
This function will grep a log file for whatever you give it, and will less the output.

First argument is mandatory and must be either the log file or the PID. We search for if *\$1 exists, else if *\$1.gz exists.
All additional args are optional.

-i : case insensitive pattern search
-v : exclude pattern from search
-d : enable debug mode
+F : set +F less flag
+G : set +G less flag
-t : set mode to tail (rather than cat)
*  : case sensitive pattern search
EOF
	return
	fi

	if [[ -z $sta ]]; then
		sta=".*"
	fi
	if [[ -z $cins ]]; then
		cins=".*"
	fi
	if [[ -z $excl ]]; then
		excl="asd1DS1D1851sf1sa118F7D181GF178S1F4S1FSF7hdfUYHDFSIUNDFYUuhfds45s1df4181815148df48sdf"
	else
		excl=$(echo $excl | sed -e 's/^|/\(/g' -e 's/$/)/g')
	fi

	function llog_cat() {
		if [[ $2 = z ]]; then
			zcat $1 | grep -P "$sta" | grep -i -P "$cins" | grep -v -E "$excl" | less -f $lessflg
		else
			cat $1 | grep -P "$sta" | grep -i -P "$cins" | grep -v -E "$excl" | less -f $lessflg
		fi
	}

	function llog_tail() {
		if [[ $2 = z ]]; then
			echo ERROR: Tail method chosen for gzipped file.
		else
			tmpfile=$(mktemp)
			tail -fn 100000 $1 | grep --line-buffered -P "$sta" | grep --line-buffered -i -P "$cins" | grep --line-buffered -v -E "$excl" > $tmpfile &
			sleep 0.2; less -f $lessflg $tmpfile; kill %; rm $tmpfile; wait $! 2>/dev/null
		fi
	}

	LESS+=S
	if [[ -z $pid ]]; then
		echo PID not specified
	elif compgen -G "$pid" >/dev/null && [[ "$pid" =~ .gz$ ]]; then
		file=$pid
		$mode $file z
	elif compgen -G "$pid" >/dev/null; then
		file=$pid
		$mode $file
	elif compgen -G "$pid.gz" >/dev/null; then
		file=$pid.gz
		$mode $file z
	elif compgen -G "./*$pid" >/dev/null && [[ "$pid" =~ .gz$ ]]; then
		file=./*$pid
		$mode $file z
	elif compgen -G "./*$pid" >/dev/null; then
		file=./*$pid
		$mode $file
	elif compgen -G "./*$pid.gz" >/dev/null; then
		file=./*$pid.gz
		$mode $file z
	elif compgen -G "$parent_dir/*$pid" >/dev/null && [[ "$pid" =~ .gz$ ]]; then
		file=$parent_dir/*$pid
		$mode $file z
	elif compgen -G "$parent_dir/*$pid" >/dev/null; then
		file=$parent_dir/*$pid
		$mode $file
	elif compgen -G "$parent_dir/*$pid.gz" >/dev/null; then
		file=$parent_dir/*$pid.gz
		$mode $file z
	else
		new_pid=$(ps auwwx | awk '$1 ~ /^pro$/ {$3=$4=$5=$6=$7=$8=""; print $0}' | grep $pid | awk "\$1\$2\$3\$4 "'!'"~ /$pid/" | grep -vE '\b(grep|awk)\b')
		if [[ $(echo "$new_pid" | wc -l) -gt 1 ]] && [[ -n $FZF ]]; then
			selection=$(echo "$new_pid" | fzf --header="ERROR: Multiple PIDs found for search string $pid. Please select one:" --no-multi -1 --height=20% --min-height=5 | awk '{print $2}')
			if [[ -n $selection ]]; then
				echo llog $selection | perl -e 'ioctl STDOUT, 0x5412, $_ for grep { $_ ne "\n" } split //, do{ chomp($_ = <>); print "\r"; $_ }'
			fi
		elif [[ $(echo "$new_pid" | wc -l) -gt 1 ]]; then
			echo -e "ERROR: Multiple PIDs found for search string $pid. Please restrict your search. PIDs found:\n$new_pid"
		elif [[ -z $new_pid ]]; then
			echo "Is $pid a PID? If so, no log file found. Is it a search pattern? If so, process does not appear to be running at the moment."
		elif compgen -G "$parent_dir/*$(echo $new_pid | awk '{print $2}')" >/dev/null; then
			file=$parent_dir/*$(echo $new_pid | awk '{print $2}')
			$mode $file
		else
			echo "File not found for $pid. We found a unique PID for this search ($new_pid), but couldn't find a file for this process in $parent_dir"
		fi
	fi
	LESS=${LESS/S/}

	if [[ -n $debug ]]; then
		echo "[DEBUG] File is $pid, view mode is $mode"
		echo "[DEBUG] Parent dir is $parent_dir"
		echo "[DEBUG] Searching for $sta, case insensitive $cins, and excluding $excl"
	fi
	if [[ -n $file ]]; then
		echo [EXIT] $file.
	fi
}

# return list of log files that contain the given command in $1
function proc() {

	# table header formatting
	header="%10s %28s %15s %25s \n"
	divider=============================================
	divider=$divider$divider$divider
	width=100
	tofind='command'
	cd_flag=
	proc=
	result=
	selection=

	flag=0 #flag for first match to print table header. if no data found flag no match
	while (( "$#" )); do
		case "$1" in
			-p|-proc)
				if [[ "$#" -lt 2 ]]; then echo "Error: flag given without process" >&2; return 1; fi
				proc=$2
				shift 2
				;;
		-cd)
			cd_flag=true
			shift
			;;
		*)
			tofind="$1"
			shift
			;;
		esac
	done
	proc="${proc:=vtServer}"
	if [ -d /local/data/hosts/$SECOND/$HOST ]; then cd /local/data/hosts/$SECOND/$HOST; else cd $RUNTIME_DATA/data/hosts/$HOST; fi
	# $1 command to find
	result=$(for line in $(files=$(find . -type f -regextype awk -regex "\./$proc.*[0-9]+(\.gz)?" | sed 's:^./::'); if [[ -n $files ]]; then ls -1tr $files; fi); do
		if [[ `( head -7 $line | zgrep  -m 1 -i "$tofind"  2> /dev/null )`  ]]; then # is the algo found in command? supress errors
			a=`stat -c '%.19y %15s %20n ' $line` # Formatted for Date to the second, total size in bytes, and file name
			b=`head  -7 $line | zgrep -m1  command $line | cut -d' ' -f4-6`
			b="${b} ..."
			if echo $a | grep -q  '.gz' ; then
				printf "%s\t%s \n" "${a}${NORMAL}" "${b}${NORMAL}"
			else
				printf "%s\t%s \n" "${a}" "${b}"
			fi
		fi
	done)
	
	hdr=$(printf "$header" "Date" "Total Size (bytes)" "File Name" "Command"; printf "%$width.${width}s \n" "$divider")

	if [[ -z $cd_flag ]]; then
		cd - >/dev/null
	fi
	unset proc

	if [[ -n $result ]] && [[ -n $FZF ]]; then
		selection=$(echo "$result" | fzf --header "$hdr" -0 --no-multi --height=40%)
	elif [[ -n $result ]]; then
		echo "$hdr"
		echo "$result"
		return
	else
		echo "No results found!"
		return
	fi
	if [[ -n $selection ]]; then
		echo llog $(echo $selection | awk '{print $4}') | perl -e 'ioctl STDOUT, 0x5412, $_ for grep { $_ ne "\n" } split //, do{ chomp($_ = <>); print "\r"; $_ }'
	fi
}

function hwshosts()
{
	if [[ -n "$1" ]]; then grep $1 /admin/var/sysid/hwshosts; else cat /admin/var/sysid/hwshosts ; fi
}

function globalhosts()
{
	if [[ -n "$1" ]]; then grep $1 /admin/var/sysid/globalhosts; else cat /admin/var/sysid/globalhosts ; fi
}

# Navigation aliases

function cde(){
	cd /srg/pro/data/etc/$1
}

function cdv()
{
	cd /srg/pro/data/var/$1
}

function cda()
{
	cd /srg/pro/data/$1
}

function cdr()
{
	cd /srg/pro/release/$1
}

function cdi()
{
	cd /srg/pro/data/var/issues/$1
}

function lti()
{
	ls -FltrA /srg/pro/data/var/issues/$1
}

function mki()
{
	[[ -n $1 ]] && mkdir -m 777 /srg/pro/data/var/issues/$1 || echo "No dir specified"
}

function cpi()
{
	if [[ -z $1 ]]; then
		echo No file to copy specified
	elif [[ -z $2 ]]; then
		echo No issues dir to copy to specified
	elif ! [[ -d /srg/pro/data/var/issues/$2 ]]; then
		echo "Issues dir ($2) does not exist. mki it first"
	elif ! [[ -f $1 ]]; then
		rsync -az /local/data/hosts/$HOST/*$1 /srg/pro/data/var/issues/$2
	else
		rsync -az $1 /srg/pro/data/var/issues/$2
	fi
}

function cdev()
{
	cd /srg/pro/data/etc/vt
}

function cdeo()
{
	dom=$(echo $DOMAIN | cut -d '-' -f2)
	if [[ $dom = de ]]; then
		cd /srg/pro/data/etc/eurex
	elif [[ $dom = bas ]]; then
		cd /srg/pro/data/etc/ice
	elif [[ $dom = ita ]]; then
		cd /srg/pro/data/etc/optiq
	elif [[ $dom = nord ]]; then
		cd /srg/pro/data/etc/nord
	elif [[ $dom = can ]]; then
		cd /srg/pro/data/etc/mdx
	elif [[ $dom = brz ]]; then
		cd /srg/pro/data/etc/puma
	elif [[ $dom = aurora ]]; then
		cd /srg/pro/data/etc/globex
	elif [[ $dom = arb ]]; then
		cd /srg/pro/data/etc/id
	elif [[ $dom = syd ]]; then
		cd /srg/pro/data/etc/asx
	elif [[ $dom = kr ]]; then
		cd /srg/pro/data/etc/krx
	fi
}

function cdvo()
{
	dom=$(echo $DOMAIN | cut -d '-' -f2)
	if [[ $dom = de ]]; then
		cd /srg/pro/data/var/eurex
	elif [[ $dom = bas ]]; then
		cd /srg/pro/data/var/ice
	elif [[ $dom = ita ]]; then
		cd /srg/pro/data/var/optiq
	elif [[ $dom = nord ]]; then
		cd /srg/pro/data/var/nord
	elif [[ $dom = can ]]; then
		cd /srg/pro/data/var/mdx
	elif [[ $dom = brz ]]; then
		cd /srg/pro/data/var/puma
	elif [[ $dom = aurora ]]; then
		cd /srg/pro/data/var/globex
	elif [[ $dom = arb ]]; then
		cd /srg/pro/data/var/id
	elif [[ $dom = syd ]]; then
		cd /srg/pro/data/var/asx
	elif [[ $dom = kr ]]; then
		cd /srg/pro/data/var/krx
	fi
}

function cdes()
{
	dom=$(echo $DOMAIN | cut -d '-' -f2)
	if [[ $dom = de ]]; then
		cd /srg/pro/data/etc/xetra
	elif [[ $dom = bas ]]; then
		cd /srg/pro/data/etc/ice
	elif [[ $dom = ita ]]; then
		cd /srg/pro/data/etc/optiq
	elif [[ $dom = nord ]]; then
		cd /srg/pro/data/etc/norc
	elif [[ $dom = can ]]; then
		cd /srg/pro/data/etc/tmx
	elif [[ $dom = brz ]]; then
		cd /srg/pro/data/etc/puma
	elif [[ $dom = aurora ]]; then
		cd /srg/pro/data/etc/globex
	elif [[ $dom = arb ]]; then
		cd /srg/pro/data/etc/gsfix
	elif [[ $dom = syd ]]; then
		cd /srg/pro/data/etc/asx
	elif [[ $dom = kr ]]; then
		cd /srg/pro/data/etc/krx
	fi
}

function cdvs()
{
	dom=$(echo $DOMAIN | cut -d '-' -f2)
	if [[ $dom = de ]]; then
		cd /srg/pro/data/var/xetra
	elif [[ $dom = bas ]]; then
		cd /srg/pro/data/var/ice
	elif [[ $dom = ita ]]; then
		cd /srg/pro/data/var/optiq
	elif [[ $dom = nord ]]; then
		cd /srg/pro/data/var/norc
	elif [[ $dom = can ]]; then
		cd /srg/pro/data/var/tmx
	elif [[ $dom = brz ]]; then
		cd /srg/pro/data/var/puma
	elif [[ $dom = aurora ]]; then
		cd /srg/pro/data/var/globex
	elif [[ $dom = arb ]]; then
		cd /srg/pro/data/var/gsfix
	elif [[ $dom = syd ]]; then
		cd /srg/pro/data/var/asx
	elif [[ $dom = kr ]]; then
		cd /srg/pro/data/var/krx
	fi
}

function loop_central()
{
	cd /srg/dev/release/prod-config/prod > /dev/null
	for n in $(ls)
	do
		if [[ $n = chi/ ]] || [[ $n = aurora/ ]]; then
			continue
		fi
		cd $n
		eval $@
		cd - > /dev/null
	done
}

function svr(){

	file=/srg/pro/data/procMan.ini
	flag=
	pre=#svrcomment
	post=
	regexString='.*'
	err=

	while [[ $# -gt 0 ]]; do
		case "$1" in
		-p|-proc)
			proc="$2"
			fullProc="^command = .*$proc.*"
			shift 2
			;;
		-s|-string)
			regexString=$2
			shift 2
			;;
		-f|-file)
			file=$2
			shift 2
			;;
		-b|-before|-pre)
			pre=$2
			shift 2
			;;
		-a|-after|-post)
			post=$2
			shift 2
			;;
		-t|-test|-n)
			flag=test
			shift
			;;
		-d|-do)
			flag=do
			shift
			;;
		-u|-undo)
			flag=undo
			shift
			;;
		-help)
			err='Usage:'
			shift
			;;
		esac
	done

	if [[ -n $err ]]; then
		echo $err
		cat << EOF
A function to primarily comment out commands in procMan for the purposes of bouncing. You can do other search and replaces, and you can also specify a different file.

-p : process
-s : string (to filter for in command) [default='.*']
-f : file [default=/srg/pro/data/procMan.ini]
-b : before string [default=#svrcomment]
-a : after string
-t : set mode to test (preview changes to file)
-d : set mode to do (make changes to file)
-u : set mode to undo (undo changes made in file)

The search and replace works as follows:
/^command = .*\$process.*\$string/\$before\1\$after/

If you don't set a mode, then you're just in grep mode and it just searches.
EOF
	return
	fi

	# Identifies which hosts are affected by any changes which will be made. Doesn't apply to undo types, as it won't show up in procflat here.
	affected_hosts=`procflat -p $proc -f $file | grep -E "$regexString" | cut -d' ' -f2 | sort -u | tr '\n' ' '`
	if [[ $flag != undo ]]; then
		echo "ctrl_procman -preview -h $affected_hosts"
		echo "ctrl_procman -read -h $affected_hosts"
	fi

	echo "Mode: $flag"

	#####
	# if no flag specified, then just grep the process from procMan
	# if flag is test, show what sed command would be done (but don't actually do it)
	# if flag is do, then actually run the sed command on that file.
	# if flag is undo, then sed remove the commented out #sv's
	#####
	if [[ -z $flag ]]; then
		grep -E --color "$fullProc$regexString" $file
	elif [[ $flag = test ]]; then
		sed -E "s/($fullProc$regexString)/$pre\1$post/g" $file | grep -E --color "$proc.*$regexString"
	elif [[ $flag = do ]]; then
		sed -i -E "s/($fullProc$regexString)/$pre\1$post/g" $file
		echo Done !
		grep -E --color "$proc.*$regexString" $file
	elif [[ $flag = undo ]]; then
		sed -i -E "s/$pre//g" $file
		grep -E --color "$proc.*$regexString" $file
	else
		echo 'Failed :('
	fi

	# If flag is undo, then these processes would now show up in procflat, so can grab the hosts now.
	affected_hosts=`procflat -p $proc -f $file | grep -E "$regexString" | cut -d' ' -f2 | sort -u | tr '\n' ' '`
		if [[ $flag = undo ]]; then
		echo "ctrl_procman -preview -h $affected_hosts"
		echo "ctrl_procman -read -h $affected_hosts"
	fi
}

function flip_links_me()
{
	# $1 should be the networks you want, in a csv list
	# $2 should be the node you want to flip to

	local check_networks=

	for net in $(echo $1 | tr ',' ' '); do
		if [[ "$net" != @(arb|bas|base|can|comm|de|ita|krx|nord|syd|us|brz|lead|current) ]];
		then
			echo "$net is not a valid node."
		else
			supro /srg/codebase/support/pgm/flip-links $net $2

			if [[ "$net" != @(base|lead|current) ]]; # dont check non_central nodes
			then
				check_networks="$check_networks,$net"
			fi
		fi
	done

	if ! [[ -z $check_networks ]]; then
		/srg/pro/data/support/tools/slack_alerts/send_comments_to_slack.sh
	fi
}

function ms()
{
	# Make script alias
	cp ~/scripts/templates/bash_script_template $1
	vim $1
}

crons ()
{
	local search=;
	local user=null;
	local err=ok;
	while [[ $# -gt 0 ]]; do
		arg=$1;
		case $arg in
			-s | -show)
				echo -e "\nThe following users have crons on this box:";
				sudo ls -1 /var/spool/cron/;
				echo -e "\n\n";
				return 0
			;;
			-help)
				echo -e "\nShows crons for all users or just the given one:";
				echo "-u        : search this user only";
				echo "-s        : show crons for all users";
				echo -e "\nAlternative usage:\n";
				echo "-s, -show";
				return 0
			;;
			*)
				user=$1
			;;
		esac;
		shift;
	done;
	if [[ $user == "null" ]]; then
		for cron in `sudo ls -1 /var/spool/cron/`;
		do
			user=$cron;
			sudo cat /var/spool/cron/$cron;
			if [ $? -eq 0 ]; then
				echo -e "\n ^-------------------------------------------------------- $user ------------------------------------------------^\n\n";
			fi;
		done;
	else
		if `sudo ls -1  /var/spool/cron/ | grep -q "$user$"`; then
			sudo crontab -l -u $user 2> /dev/null;
		else
			echo "No cronjob found for this user on this box, available users:";
			sudo ls -1 /var/spool/cron/;
		fi;
	fi
}

clean ()
{
	days=0
	force=
	dryrun=
	while [[ $# -gt 0 ]]; do
		case "$1" in
		-days)
			days="$2"
			shift 2
			;;
		-f)
			force='-force'
			shift
			;;
		-n)
			dryrun='-n'
			shift
			;;
		-help)
			err='Usage:'
			shift
			;;
		*)
			err="Unrecognised argument $1"
			shift
			;;
		esac
	done

	if [[ -n $err ]]; then
		echo $err
		cat << EOF
Clean a directory of old files.

-days : INT : how many days old the files have to be to be deleted
-f : FLAG : force delete (ie if not owned by me)
-n : FLAG : dryrun
EOF
	return
	fi
	~/scripts/housekeep.sh -delete -dir . -days 0 $force $dryrun
}

vwhich ()
{
	vim $(which $1)
}

vscp ()
{
	vim scp://$1/$2
}

gou()
{
	if [[ -z $1 ]]; then
		echo Need to specify user as first arg and optionally d as second arg to sudo to them.
	else
		user=$1
		flag=
		if [[ $2 = d ]]; then
			flag='-disp'
		elif [[ -n $2 ]]; then
			echo "WARNING: Unrecognised argument: $2"
		fi
		~/scripts/goto -user $user $flag
	fi
}

gout()
{
	tmux-split-cmd () {
		tmux split-window -dh -t $TMUX_PANE "bash --rcfile <(echo '. ~/.bashrc;$*')"
		tmux select-pane -R -t $TMUX_PANE
	}

	if [[ -z $1 ]]; then
		echo Need to specify user.
	else
		user=$1
		tmux-split-cmd "~/scripts/goto -user $user -disp"
		~/scripts/goto -user $user
	fi
}

gop()
{
	additional=
	if [[ -n $1 ]] && [[ -n $2 ]]; then
		if [[ -n $3 ]]; then
			additional="-f $3"
		fi
		~/scripts/goto -net "$1" -p "$2" $additional
	else
		echo Need to provide at least two arguments for the network and the process. Optional third to filter.
	fi
}

tgb()
{
	box=$(tmux display-message -p '#W')
	if [[ -z $box ]]; then
		echo "tmux window has no name, so no box to go to."
	elif ! grep -q "^$box:" /admin/var/sysid/globalhosts; then
		echo "$box not found in globalhosts file"
	else
		ssh $box; lo
	fi
}

svscst()
{
	ssh -X uk01dw919 'echo /home/svora/scripts/strippedStackDump | tmux loadb -' 2>/dev/null
	sudo su - pro
}

devpull()
{
	if [[ -z $2 ]]; then echo error;
	else
		devfile=$(echo $1 | sed -E "s?^\./?$(pwd)/?g")
		rsync uk01vis710:$devfile $2
	fi
}

devpush()
{
	if [[ -z $2 ]]; then echo error;
	else
		devloc=$(echo $2 | sed -E "s?^\.\$?$(pwd)/?g")
		rsync $1 uk01vis710:$devloc/
	fi
}

mkpatch()
{
	main=$(git branch --show-current)
	trap "git checkout $main" INT
	if git branch | grep -q '\ssv$'; then 
		git checkout sv
	else
		git checkout -b sv
	fi
	read -p 'Commit message: ' -r
	git commit -m "$REPLY"
	git format-patch -1
	git checkout $main
	git branch -D sv
	trap - INT
}

appatch()
{
	if [[ $1 =~ ^00 ]]; then
		git am < $1
	elif [[ $1 =~ \.patch$ ]]; then
		git apply $1
	fi
	err_code=$?
	if [[ $err_code -eq 0 ]]; then
		echo -e "Successfully applied patch $1.\nRemoving the patch."
		rm $1
	else
		echo -e "=========================================\nERROR: Something went wrong with applying that patch.\nERROR: Will not remove the patch.\n========================================="
	fi
}

pff()
{
	/home/svora/scripts/procflatAdj $@ | fzf --height 40%
}

pfg()
{
	host=$(/home/svora/scripts/procflatAdj $@ | fzf --no-multi --height 40% -1 --header='Press Enter to go to selected host.' | awk '{print $2}')
	if [[ -n $host ]]; then
		ssh -X $host
	fi
}

v()
{
	if [[ -n $1 ]]; then
		find . -type f | fzf -1 --height=15% --query="$1"| xargs -r bash -c 'vim "$@" < /dev/tty' vim
	else
		find . -type f | fzf -1 --height=15% | xargs -r bash -c 'vim "$@" < /dev/tty' vim
	fi
}

k()
{
	if [[ -n $1 ]]; then
		extra="--query '$1'"
	else
		extra=
	fi
	pid=$(ps -eo user,pid,ppid,%cpu,%mem,comm --sort -%mem | fzf --height=25% --bind='alt-c:reload(ps -eo user,pid,ppid,%cpu,%mem,comm --sort -%cpu,-%mem),alt-m:reload(ps -eo user,pid,ppid,%cpu,%mem,comm --sort -%mem,-%cpu)' --header='Sort by CPU(A-c) or MEM(A-m)' $extra)

	if [[ $(echo $pid | awk '{print $1}') == $USER ]];
	then kill $(echo $pid | awk '{print $2}')
	elif [[ -n $pid ]];
	then sudo kill $(echo $pid | awk '{print $2}')
	fi
}

function h()
{
	if [[ -n $1 ]]; then
		grep "$1" /home/svora/dotfiles/.bash_history | awk '!x[$0]++' | fzf --no-multi --tac --height=75% | perl -e 'ioctl STDOUT, 0x5412, $_ for grep { $_ ne "\n" } split //, do{ chomp($_ = <>); print "\r"; $_ }'
	else
		cat /home/svora/dotfiles/.bash_history | awk '!x[$0]++' | fzf --no-multi --tac --height=75% | perl -e 'ioctl STDOUT, 0x5412, $_ for grep { $_ ne "\n" } split //, do{ chomp($_ = <>); print "\r"; $_ }'
	fi
}

cdh()
{
	builtin cd
}

# cd()
# {
    # if [[ "$#" != 0 ]]; then
        # builtin cd "$@";
        # return
    # fi
    # while true; do
        # local lsd=$(echo ".." && ls -p -1 | grep '/$' | sed 's;/$;;')
        # local dir="$(printf '%s\n' "${lsd[@]}" |
            # fzf --reverse --preview '
                # __cd_nxt="$(echo {})";
                # __cd_path="$(echo $(pwd)/${__cd_nxt} | sed "s;//;/;")";
                # echo $__cd_path;
                # echo;
                # ls -p -1 --color=always "${__cd_path}";
        # ')"
        # [[ ${#dir} != 0 ]] || return 0
        # builtin cd "$dir" &> /dev/null
    # done
# }
