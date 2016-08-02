#!/bin/bash
## lockify.sh for lockify in /home/roman_p/Dropbox/Scripts
## 
## Made by Paul Roman
## Login   <roman_p@epitech.net>
## 
## Started on  Tue Apr 19 13:52:35 2016 Paul Roman
## Last update Tue Aug  2 14:09:45 2016 Paul Roman
##

getMetaData()
{
    SP_DEST="org.mpris.MediaPlayer2.spotify"
    SP_PATH="/org/mpris/MediaPlayer2"
    SP=MEMB="org.mpris.MediaPlayer2.Player"

    if [ $1 == id ]
    then
	dbus-send --print-reply --dest=$SP_DEST $SP_PATH org.freedesktop.DBus.Properties.Get string:"$SP_MEMB" string:'Metadata' |\
	    awk 'NR == 13' | cut -c58- | sed 's/.$//'
    elif [ $1 == artist ]
    then
	dbus-send --print-reply --dest=$SP_DEST $SP_PATH org.freedesktop.DBus.Properties.Get string:"$SP_MEMB" string:'Metadata' |\
	    awk 'NR == 22' | cut -c27- | sed 's/.$//'
    elif [ $1 == album ]
    then
	dbus-send --print-reply --dest=$SP_DEST $SP_PATH org.freedesktop.DBus.Properties.Get string:"$SP_MEMB" string:'Metadata' |\
	    awk 'NR == 17' | cut -c44- | sed 's/.$//'
    elif [ $1 == title ]
    then
	dbus-send --print-reply --dest=$SP_DEST $SP_PATH org.freedesktop.DBus.Properties.Get string:"$SP_MEMB" string:'Metadata' |\
	    awk 'NR == 39' | cut -c44- | sed 's/.$//'
    fi
}

lockify()
{
    i3lock -i lockify.png
    trap "" INT
    path=".shot.png"
    id=`getMetaData id`
    album=`getMetaData album`
    artist=`getMetaData artist`
    title=`getMetaData title`
    url=`curl -SsX GET "https://api.spotify.com/v1/tracks/$id" | awk 'NR == 12' | cut -c16- | sed 's/..$//'`
    wget -nv $url -O $path &> /dev/null
    
    cp $path .orig.png
    convert $path -resize "1920x1920" $path
    convert $path -crop 1920x1920+0+420 $path
    convert $path -crop 1920x1920+0+-420 $path
    convert $path -channel RGBA -blur 0x10 $path
    convert $path .orig.png -gravity center -composite -matte $path 
    rm .orig.png
    convert $path -font BorisBlackBloxx -weight 50 -pointsize 50 -stroke black -draw "gravity north fill white text 0,475 \"$title
$artist  |  $album\" " $path
    kill `pidof i3lock`
    if (i3lock -i $path)
    then
	rm $path
    fi
}

isI3lockInstalled=`which i3lock`
isConvertInstalled=`which convert`
if [ -z "$isI3lockInstalled" ]
then
    >&2 echo "i3lock is not installed"
    
else
    if [ -z "$isConvertInstalled" ]
    then
	>&2 echo "ImageMagick is not installed"
    else
	isRunning=`ps -x | grep [s]potify`
	if [ -n "$isRunning" ]
	then
	    lockify
	else
	    >&2 echo "Spotify is not running"
	fi
    fi
fi
