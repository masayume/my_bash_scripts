#!/bin/bash

DIR1=/home/masayume/DATA/L/GODOT/MY_PROJECTS/godot-starforce
DIR2=/home/masayume/DATA/E/INSPIRE/PROJECTS/starforce-reference/
INFO=/home/masayume/DATA/E/INSPIRE/PROJECTS/starforce-reference/starforce.infogen.txt
TODO=/home/masayume/DATA/E/INSPIRE/PROJECTS/starforce-reference/starforce.TODONEXT.txt

dolphin --new-window --split "$DIR1" "$DIR2" &

echo
echo " >>> TODO NEXT: "

cat "$TODO"
echo

subl "$INFO" 

echo