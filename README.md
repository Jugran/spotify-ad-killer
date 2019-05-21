# Spotify Ad-Killer
A BASH script which skips Advertisements in Spotify free account.

>Please **Do NOT** overuse this script! 

Spotify is an amazing music streaming service and worth the premium subscription.
This script was created out of my curiosity and it is intended to be used for **testing purposes only!**
I do not take responsibility for any future action taken on your account by Spotify due to abusive use of this script.

- - - - 

#### Working
This script uses dbus-send messages to detect Advertisements and restarts the Spotify application to skip the ad and play the next track automatically.

Some implementations mutes the ads instead of skipping it like [SecUpwN's Spotify-AdKiller](https://github.com/SecUpwN/Spotify-AdKiller) which adds a long silence between the tracks. This script instead restarts the application within few seconds (depending on the hardware and OS) and skips the Ads instead of muting them.


### Installation
Simply clone the repository.
``` 
git clone https://github.com/Jugran/spotify-ad-killer
```

### Usage
Make script executable and run
```
chmod +x spotify-ad-killer.sh
./spotify-ad-killer.sh
```
This script can be made to run at login automatically by placing it in ```/etc/profile.d``` directory.

- - - - 
