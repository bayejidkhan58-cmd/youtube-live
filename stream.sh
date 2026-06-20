#!/bin/bash
VIDEO_URL="https://www.dropbox.com/scl/fi/t2j8abgo2lssd4mj2usjy/.mp4.mp4?rlkey=h5tknpd2qpm0ld1umk9w0og2j&st=4fpzl7q4&dl=1"
wget -O video.mp4 "$VIDEO_URL"
ffmpeg -re -stream_loop -1 -i video.mp4 \
  -t 10800 \
  -c:v libx264 -preset veryfast -b:v 3000k \
  -g 48 -keyint_min 48 \
  -c:a aac -b:a 128k \
  -f flv "rtmp://a.rtmp.youtube.com/live2/$STREAM_KEY"
