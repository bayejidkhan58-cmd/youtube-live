#!/bin/bash
VIDEO_URL="https://www.dropbox.com/scl/fi/fw544gii8ww6co101vli9/.mp4.mp4?rlkey=u7b6tfmbgn3k8lq9wkqrjvsyf&st=fp42xyts&dl=1"
STREAM_KEY=pdu9-wert-z2se-zw9w-dg7r
ffmpeg -re -stream_loop -1 -i "$VIDEO_URL" -c:v libx264 -preset ultrafast -b:v 1000k -c:a aac -b:a 96k -f flv "rtmp://a.rtmp.youtube.com/live2/$STREAM_KEY"
