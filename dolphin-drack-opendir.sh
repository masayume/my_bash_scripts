#!/bin/bash

DIR1=/home/masayume/DATA/E/PROJECTS/GODOT/MY_PROJECTS/godot-drack/ 
DIR2=/home/masayume/DATA/E/INSPIRE/PROJECTS/drack-reference/
INFO=/home/masayume/DATA/E/INSPIRE/PROJECTS/drack-reference/drack.infogen.txt
TODO=/home/masayume/DATA/E/INSPIRE/PROJECTS/drack-reference/drack.TODONEXT.txt

dolphin --new-window --split "$DIR1" "$DIR2" &

echo
echo " >>> TODO NEXT: "

cat "$TODO"
echo

subl "$INFO" 

echo
