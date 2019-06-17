#!/bin/bash

#	Spotify is an amazing music streaming service and worth the premium 
#	subscription. This script was created out of my curiousity and it is 
#	intended to be used for testing purposes only! I do not take responsibility 
#	for any future action taken on your account by Spotify due to abusive 
#	use of this script.


wait_for_spotify()
{
	# $1=1 wait for spotify to start
	# $2=0 wait for spotify to close

	(pgrep spotify > /dev/null)
	running_code=$?

	while [[ $(($running_code ^ $1)) == 0 ]]
	do
		sleep ${2:-1}	# sleep for $2 seconds; default: 1s
		(pgrep spotify > /dev/null)
		running_code=$?

		echo -n .
	done
}

play()
{
	until ( dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify \
	/org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Play  > /dev/null 2>&1 )
	do
		sleep 0.2
	done
}

restart_spotify()
{

	start_time="$(date -u +%s.%N)"

	echo "closing spotify"
	(killall spotify)
	wait_for_spotify 0 $1 	# close
	
	end_time="$(date -u +%s.%N)"
	elapsed="$(bc <<<"$end_time-$start_time")"
	echo "closing time: "$elapsed Secs

	start_time="$(date -u +%s.%N)"
	echo "Starting spotify"
	(spotify &>/dev/null &)

	wait_for_spotify 1 $1	# start
	play

	end_time="$(date -u +%s.%N)"
	elapsed="$(bc <<<"$end_time-$start_time")"
	echo "sarting time: "$elapsed Secs
}


echo "waiting for spotify..."
wait_for_spotify 1 20 	# start
echo "spotify started"

while true
do
	until dbus_msg=$( dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify \
		/org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get  \
		string:'org.mpris.MediaPlayer2.Player' \
		string:'Metadata' 2>&1 )
	do
		sleep 20
		echo -n .
	done
	
	if (echo $dbus_msg | grep -q "spotify:ad" )
	then
		# ad detected; skip ad
		echo "Ad detected! restarting..."
		start_t="$(date -u +%s.%N)"

		restart_spotify 0.5		# delay secs

		end_t="$(date -u +%s.%N)"
		elapsed="$(bc <<<"$end_t-$start_t")"
		echo "Spotify restarted: " $elapsed Secs

	fi

	sleep 2
done
