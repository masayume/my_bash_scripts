#!/bin/bash

DIR1=/home/masayume/DATA/L/GODOT/MY_PROJECTS/godot-solomon
DIR2=/home/masayume/DATA/E/PROJECTS/SOLOMONS\'s\ WORLD/
INFO=/home/masayume/DATA/E/PROJECTS/SOLOMONS\'s\ WORLD/solomonsworld.infogen.txt
TODO=/home/masayume/DATA/E/PROJECTS/SOLOMONS\'s\ WORLD/solomonworld.TODONEXT.txt

dolphin --new-window --split "$DIR1" "$DIR2" &

echo
echo " >>> TODO NEXT: "

cat "$TODO"
echo

subl "$INFO" 

echo