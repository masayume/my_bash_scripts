#!/bin/bash

DIR1=/home/masayume/DATA/E/PROJECTS/GODOT/MY_PROJECTS/godot-tennnees/ 
DIR2=/home/masayume/DATA/E/INSPIRE/PROJECTS/tennnees-reference/
INFO=/home/masayume/DATA/E/INSPIRE/PROJECTS/tennnees-reference/tennnees.infogen.txt
TODO=/home/masayume/DATA/E/INSPIRE/PROJECTS/tennnees-reference/ARCHITECTURE.md

dolphin --new-window --split "$DIR1" "$DIR2" &

echo
echo " >>> TODO NEXT: "

cat "$TODO"
echo

subl "$INFO" 

echo
