#!/bin/bash
##############################################
# This file contains all of my bash functions
# This includes small ones for faster cd-ing, as well as bigger ones such as proc or svr
# ############################################

# return list of log files that contain the given command in $1
function proc() { 

     # table header formatting
    header="\n %10s %28s %15s %25s \n"
    divider=============================================
    divider=$divider$divider$divider
    width=100
    tofind='command'
        
    flag=0 #flag for first match to print table header. if no data found flag no match
    while (( "$#" )); do 
        case "$1" in
        -p|-proc)
            if [[ "$#" -lt 2 ]]; then echo "Error: flag given without process" >&2; return 1; fi
            proc=$2
            shift 2
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
    for line in $(ls -1tr $proc* ); do
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
		echo Issues dir does not exist. mki it first
	else
		cp $1 /srg/pro/data/var/issues/$2
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

function central()
{
    cd /srg/dev/release/prod-config/prod/$1; pwd
}

function loop_central()
{
	cd /srg/dev/release/prod-config/prod > /dev/null
	for n in $(ls)
	do
		if [[ $n = chi/ ]]; then 
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
    pre=#sv
    post=
    regexString='.*'

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
        esac
    done

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
        sed -i -E "s/#sv//g" $file
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

function flip-links-me()
{
    # $1 should be the networks you want, in a csv list
	# $2 should be the node you want to flip to

    local check_networks=

    for net in $(echo $1 | tr ',' ' '); do
        if [[ "$net" != @(arb|bas|base|can|comm|de|ita|krx|nord|syd|us|brz|lead|current) ]];
        then
            echo "$net is not a valid node."
        else
            supro flip-links $net $2

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

function cp_issues()
{
	# $1 should be the file to copy
	# $2 should be the ticket number
	
	iss_dir=/srg/pro/data/var/issues/$2
	if ! [[ -d $iss_dir ]]; then
		mkdir $iss_dir
		chmod 777 $iss_dir
	fi
	cp $1 $iss_dir
	chmod 666 $iss_dir/$1
}

function ms()
{
	# Make script alias
	cp ~/scripts/templates/bash_script_template $1
	vim $1
}
