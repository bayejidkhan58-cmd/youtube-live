#!/bin/bash
VIDEO_URL="https://www.dropbox.com/scl/fi/nx2vz3ynbzz5rttukh7j5/.mp4.mp4?rlkey=p4vy3m0hqg5hbvr07gtx5cief&st=684n3lzj&dl=1"
wget -O video.mp4 "$VIDEO_URL"
ffmpeg -re -stream_loop -1 -i video.mp4 \
  -t 10800 \
  -c:v libx264 -preset veryfast -b:v 3000k \
  -g 48 -keyint_min 48 \
  -c:a aac -b:a 128k \
  -f flv "rtmp://a.rtmp.youtube.com/live2/$STREAM_KEY"
