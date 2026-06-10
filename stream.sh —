#!/bin/bash
VIDEO_URL="https://drive.google.com/uc?export=download&id=1eUsRUHW-nZTSYPneaAd0CTbnzh4VIMcj&confirm=t"
STREAM_KEY=pdu9-wert-z2se-zw9w-dg7r
ffmpeg -re -stream_loop -1 -i "$VIDEO_URL" \
  -c:v libx264 -preset veryfast -b:v 3000k \
  -c:a aac -b:a 128k \
  -f flv "rtmp://a.rtmp.youtube.com/live2/$STREAM_KEY"
