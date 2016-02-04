# Start/Stop script for running Kismet on a WiFi Pineapple with a USB GPS
#!/bin/bash

if [[ "$1" == "start" ]]
then
    echo "Starting Kismet..."

    # Initialize GPS device
    gpsd -n /dev/ttyUSB0

    # Put the second antenna in monitor mode
    ifconfig wlan1 down
    iwconfig wlan1 mode monitor

    # Start Kismet
    kismet_server --daemonize
elif [[ "$1" == "stop" ]]
then
    # Stop Kismet
    echo -e '\n!0 shutdown' | nc localhost 2501

    # Download the capture files
    tar cvzf /sd/kismet.tar.gz /sd/kismet/*
    scp /root/kismet.tar.gz root@172.16.42.239:/sd/kismet.tar.gz
else
    echo "kiswalk.sh [start/stop]"
fi
