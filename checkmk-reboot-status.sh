#!/bin/bash
if [ -e /var/run/reboot-required ]; then
    status=2
    statustxt="CRITICAL - Restart required due to pending updates"
else
    status=0
    statustxt="OK - No restart required due to pending updates"
fi

echo "$status Reboot-Status varname=2;crit $statustxt"