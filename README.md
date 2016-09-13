# lockify

[![Build Status](https://travis-ci.org/paul-roman/lockify.svg?branch=master)](https://travis-ci.org/paul-roman/lockify)
[![StyleCI](https://styleci.io/repos/49778645/shield)](https://styleci.io/repos/49778645)

Shell script to lock your screen with the current song you're listening to with Spotify

## V1.1
Upgrade of the bus session request to conform to Spotify v1.0.*

# Needed programs
To execute the script, you need two programs :
First of all, you need i3lock, to lock your screen with a PNG picture.
Then, you need imagemagick, which is providing tools for pictures command-line editing.

#Utilisation
All you need to do is launch Spotify, and execute the lockify.sh.
He will by itself get metadatas (thanks to sp.sh), contact Spotify's web API, return the album covert art, and edit it with your screen size, with a blur and the song's details.