#!/usr/bin/bash

getArtistName() {
    # I wrote this one to take one argument and set a global variable to the 
    # artist's name with whitespace removed
    # Note that this is where you'll want/need to use ffprobe
    artistName=$(ffprobe -show_format -loglevel quiet "$1" | grep -i "TAG:ARTIST"| cut -d "=" -f2 | tr -d " ")
}

getSongName() {
    # Same deal as getArtistName but with the song name
    # Note that this is where you'll want/need to use ffprobe
    songName=$(ffprobe -show_format -loglevel quiet "$1" | grep -i "TAG:TITLE" | cut -d "=" -f2 | tr -d " ")
}

doConversion() {
    # This function performs the conversion on a single file
    getArtistName "$1"
    getSongName "$1"
    ffmpeg -i "$1" -y "$TARGET_DIR/${artistName}_${songName}.mp3"
    rm "$1"
}

# Takes one argument, that being a directory
TARGET_DIR=$1

# Now we should iterate over every file in the directory and do the conversion
# for each file
for i in "$TARGET_DIR"/*
do
  doConversion "$i";
done
