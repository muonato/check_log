#!/usr/bin/env bash
#
# muonato/check_logs @ GitHub (18-MAR-2026)
#
# Reports latest match for search phrase in a log file
#
# Usage:
#       bash check_log.sh -f </path/log> -s <keyword>
#
# Arguments:
#       -f : path to log file
#       -s : search phrase
#
# Options:
#       -h : Display help
#       -w : warning threshold ( default: 7 days )
#       -c : critical threshold ( default: 3 days )
#
# Examples:
#       1. Search keyword in logfile
#
#          $ bash check_log.sh -f /path/to/sys.log -s "ERROR"
#

function help() {
        cat <<EOF
check_log 18-MAR-2026 muonato@github
Usage: $(basename "$0") -f </path/to/file> -s '<search>' [OPTIONS]

OPTIONS
    -h display this help menu
EOF
exit 3
}

function status() {
        # Function reports status
        # and exits /w given code

        TIMESTAMP="$1"
        STATUSTXT="$2"
        STATUSNUM=$3

        echo -e "$TIMESTAMP $(basename $LOGF): $STATUSTXT"
        exit $STATUSNUM
}

# Script arguments validation
while getopts "hf:s:w:c:" opt; do
    case "$opt" in
        h)  help;;
        f)  LOGF=$OPTARG;;
        s)  KEYW=$OPTARG;;
        w)  WARN=$OPTARG;;
        c)  CRIT=$OPTARG;;
    esac
done

# Alert threshold
WARN=${WARN:-"7"}
CRIT=${CRIT:-"3"}

TODAY=$(date "+%Y-%m-%d %H:%M:%S")

if [[ -e $LOGF ]]; then
        # Match keyword if log file exists
        MESG=$(grep "$KEYW" $LOGF|tail -1)
else
        # Exit with unknown status
        status "$TODAY" "File not found" 3
fi

if [[ -z $MESG ]]; then
        status "$TODAY" "Nothing to alert" 0
fi

# Unix epoch today
DNOW=$(date '+%s')

# Look for timestamp patterns in log entry
LSDT=$(echo $MESG | grep -oE ".{11}[0-9]{2}:[0-9]{2}:[0-9]{2}")

if [[ -n $LSDT ]]; then
        # Date of entry to unix epoch
        DXPO=$(date -d "$LSDT" "+%s")
else
        DXPO=$DNOW
fi

# Days passed since matched timestamp
DAYS=$(( ( DNOW - DXPO )/(60*60*24) ))

if [[ $DAYS -le $CRIT ]]; then
        status "$LSDT" "$KEYW" 2
fi

if [[ $DAYS -le $WARN ]]; then
        status "$LSDT" "$KEYW" 1
fi

status "$TODAY" "Last alert ($DAYS) days ago" 0
