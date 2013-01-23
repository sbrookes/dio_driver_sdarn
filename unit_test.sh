
# unit test for my first pedagogical driver

#check input
if [ $# -lt 2 ]
  then 
    echo "Usage: give the name of the module and mode"
    exit 1
fi

#retrive the module and its status
mod=$1
open=`lsmod | grep -c $mod`
opt=$2

if [ $opt != "c" ] 
    then

    if [ $open = "1" ]
	then
	
	echo "you shouldn't open this again"
	exit 2
    fi
	
    #first make the module
    echo "making the module"
    rm -f ./$mod.ko
    sudo make 

    # now install the module
    echo "installing the module"
    ./dio_mknod.sh

    # check the logs
    echo "Pause, then Checking logs"
    sleep 1
    tail --lines=1 /var/log/kern.log
fi

open=`lsmod | grep -c $mod`

if [ $opt != "o" ]
    then

    if [ $open = "0" ]
	then
	
	echo "you need to open this first"
	exit 2
    fi

    # now remove the module
    echo "Removing the module"
    sudo rmmod $mod

    # remove old nodes
    sudo rm -f /dev/${mod}*

    # check the logs
    echo "Pause, then Checking logs"
    sleep 1
    tail --lines=1 /var/log/kern.log

fi