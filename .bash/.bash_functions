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
cdv      - cd /srg/pro/data/var and subdirs
cde      - cd /srg/pro/data/etc and subdirs
cda      - cd /srg/pro/data and subdirs
cdr      - cd /srg/pro/release and subdirs
cdev     - cd /srg/pro/data/etc/vt
cd(e|v)o - cd to corresponding dir for options/derivatives on this given network
cd(e|v)s - cd to corresponding dir for stocks on this given network
c        - cd /srg/dev/release/prod-config/prod and subdirs if in devlon, else cd /srg/pro/data/ and subdirs
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
svscst         - become pro and add /home/svora/scripts/strippedStackDump to tmux buffer
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

	if [[ -z $pid ]]; then
		echo PID not specified
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
		if [[ $(echo "$new_pid" | wc -l) -gt 1 ]]; then
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

	if [[ -n $debug ]]; then
		echo "File is $pid, view mode is $mode"
		echo "Parent dir is $parent_dir"
		echo "Searching for $sta, case insensitive $cins, and excluding $excl"
	fi
	if [[ -n $file ]]; then
		echo Reading $file.
	fi
}

# return list of log files that contain the given command in $1
function proc() {

	# table header formatting
	header="\n %10s %28s %15s %25s \n"
	divider=============================================
	divider=$divider$divider$divider
	width=100
	tofind='command'
	cd_flag=
	proc=

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
	for line in $(ls -1tr $proc* | grep -vE 'evtdump|\.csv'); do
		if [[ `( head -7 $line | zgrep  -m 1 -i "$tofind"  2> /dev/null )`  ]]; then # is the algo found in command? supress errors
			if [[ $flag ==  "0" ]]; then
				printf "$header" "Date" "Total Size (bytes)" "File Name" "Command"
				printf "%$width.${width}s \n" "$divider"
				flag=1
			fi
			a=`stat -c '%.19y %15s %20n ' $line` # Formatted for Date to the second, total size in bytes, and file name
			b=`head  -7 $line | zgrep -m1  command $line | cut -d' ' -f4-6`
			b="${b} ..."
			if echo $a | grep -q  '.gz' ; then
				printf "%s\t%s \n" "${a}${NORMAL}" "${b}${NORMAL}"
			else
				printf "%s\t%s \n" "${a}" "${b}"
			fi
		fi
	done

	if [[ $flag == "0" ]]; then
		printf "\n%s \n\n" "No matches found!"
	fi
	if [[ -z $cd_flag ]]; then
		cd - >/dev/null
	fi
	unset proc
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
	[[ -n $1 ]] && mkdir /srg/pro/data/var/issues/$1 || echo "No dir specified"
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

function c()
{
	if [[ $DOMAIN = "dev-lon" ]]; then
		cd /srg/dev/release/prod-config/prod/$1; pwd
	else
		cd /srg/pro/data/$1; pwd
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
		~/scripts/goto -net "$1" -p "$2" "$additional"
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
	ssh -X uk01dw708 'echo /home/svora/scripts/strippedStackDump | tmux loadb -' 2>/dev/null
	sudo su - pro
}
