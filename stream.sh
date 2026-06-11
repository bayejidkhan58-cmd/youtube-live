#!/bin/bash
STREAM_KEY=pdu9-wert-z2se-zw9w-dg7r
ffmpeg -re -stream_loop -1 -i "video.mp4" -c:v libx264 -preset ultrafast -b:v 1500k -c:a aac -b:a 128k -f flv "rtmp://a.rtmp.youtube.com/live2/$STREAM_KEY"
