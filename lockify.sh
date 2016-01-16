#!/bin/sh
## lockify.sh for lockify in /home/roman_p/Dropbox/Scripts
## 
## Made by Paul Roman
## Login   <roman_p@epitech.net>
## 
## Started on  Sun Jan 10 10:31:48 2016 Paul Roman
## Last update Sat Jan 16 16:44:53 2016 Paul Roman
##

if ./sp.sh 1>/dev/null 2>/dev/null;
then
    i3lock -i lockify.png
    trap "" INT
    path=".shot.png"
    id=`./sp.sh metadata | awk 'NR == 11' | cut -c19-`
    album=`./sp.sh metadata | awk 'NR == 4' | cut -c7-`
    artist=`./sp.sh metadata | awk 'NR == 5' | cut -c8-`
    title=`~./sp.sh metadata | awk 'NR == 9' | cut -c7-`
    url=`curl -SsX GET "https://api.spotify.com/v1/tracks/$id" | awk 'NR == 12' | cut -c16- | sed 's/..$//'`
    wget -nv $url -O $path

    cp $path .orig.png
    convert $path -resize "1920x1920^<" $path
    convert $path -crop 1920x1920+0+420 $path
    convert $path -crop 1920x1920+0+-420 $path
    convert $path  -channel RGBA  -blur 0x15 $path
    convert $path .orig.png -gravity center -composite -matte $path 
    rm .orig.png
    convert $path -font BorisBlackBloxx -weight 50 -pointsize 50 -stroke black -draw "gravity north fill white text 0,475 \"$title
$artist  |  $album\" " $path
    kill `pidof i3lock`
    i3lock -i $path
    rm $path
else
    i3lock -i ~/Images/smooth.png
fi
