#!/bin/bash
ffmpeg -re -stream_loop -1 -i "video.mp4" \
  -c:v libx264 -preset veryfast \
  -b:v 3000k -maxrate 3000k -bufsize 6000k \
  -pix_fmt yuv420p -g 50 \
  -c:a aac -b:a 160k -ac 2 \
  -f flv "rtmp://a.rtmp.youtube.com/live2/${STREAM_KEY}"
