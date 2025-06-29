#!/bin/bash
set -u
set -o pipefail

HOST=192.168.68.53
LOG=/home/pi/barograph/barograph.data
# limit last 200 rows
tail -n 200 $LOG > $LOG.tmp && mv $LOG.tmp $LOG
OFFSET=31

echo -n "`date +%F_%H:%M` " >> $LOG

PRESSURE=`curl -s http://$HOST:3000/signalk/v1/api/vessels/self/environment/outside/pressure | jq '.value'`
if [ $? -ne 0 ]; then
    echo "cannot access to SignalK"
    exit
fi
RESULT_PRESS=`echo "scale=1; $PRESSURE/100 + $OFFSET" | bc`

TEMPERATURE=`curl -s http://$HOST:3000/signalk/v1/api/vessels/self/environment/outside/temperature | jq '.value'`
if [ $? -ne 0 ]; then
    echo "cannot access to SignalK"
    exit
fi
RESULT_TEMP=`echo "scale=1; $TEMPERATURE - 273.15" | bc`

echo "$RESULT_PRESS $RESULT_TEMP" >> $LOG
