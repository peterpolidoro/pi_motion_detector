#!/bin/sh

now=$(date +"%Y-%m-%d-%S")
filename="/home/pi/motion/on_area_detected.$now.txt"
touch $filename
export PATH=/usr/local/bin:$PATH

gpio mode 1 out
gpio write 1 1
sleep 1
gpio write 1 0
