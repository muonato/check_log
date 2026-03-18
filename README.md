# check_log
Log file monitoring for a search phrase

## Usage
```
bash check_log.sh -f </path/log> -s <keyword>

Arguments:
       -f : path to log file
       -s : search phrase

Options:
       -h : Display help
       -w : warning threshold ( default: 7 days )
       -c : critical threshold ( default: 3 days )
```

## Monitoring setup
Specify command in your nrpe configuration file on host

```
command[check_log]=/path/to/plugins/check_log.sh $ARG1$
```

Set command (check_nrpe) on your nagios monitoring server

```
-H $HOSTADDRESS$ -c check_log -a '-f /var/log/foobar.log -s "ERROR"'
```

## Examples
Search keyword in logfile
```
$ bash check_log.sh -f /path/to/sys.log -s "ERROR"
```

## Platform
Script development and testing
```
GNU bash, version 5.1.8(1)-release (x86_64-redhat-linux-gnu)
Red Hat Enterprise Linux 9.7 (Plow)
OpenSSL 3.5.1 1 Jul 2025
Opsview Core 3.20140409.0
```
