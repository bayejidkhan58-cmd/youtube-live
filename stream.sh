#!/bin/bash
STREAM_KEY=9y5u-ut2b-y1g5-y6q4-d9v3
ffmpeg -re -stream_loop -1 -i "video.mp4" -c:v libx264 -preset ultrafast -b:v 1500k -c:a aac -b:a 128k -f flv "rtmp://a.rtmp.youtube.com/live2/$STREAM_KEY"
