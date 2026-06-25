#!/bin/bash
set -e

# Download all videos first
echo "Downloading videos..."
wget -O v1.mp4 "https://www.dropbox.com/scl/fi/xxxxx/v1.mp4?dl=1"
wget -O v2.mp4 "https://www.dropbox.com/scl/fi/xxxxx/v2.mp4?dl=1"
wget -O v3.mp4 "https://www.dropbox.com/scl/fi/xxxxx/v3.mp4?dl=1"
wget -O v4.mp4 "https://www.dropbox.com/scl/fi/xxxxx/v4.mp4?dl=1"

# Build playlist
echo "file 'v1.mp4'
file 'v2.mp4'
file 'v3.mp4'
file 'v4.mp4'" > playlist.txt

# Start stream, auto-stop after exactly 4 hours (14400 seconds)
echo "Starting Shorts-ready vertical stream for 4 hours..."
timeout 14400 ffmpeg -re -stream_loop -1 -f concat -safe 0 -i playlist.txt \
  -vf "scale=1080:1920:force_original_aspect_ratio=decrease,pad=1080:1920:(ow-iw)/2:(oh-ih)/2" \
  -c:v libx264 -preset veryfast -b:v 3000k \
  -g 48 -keyint_min 48 \
  -c:a aac -b:a 128k -ar 44100 \
  -f flv "rtmp://a.rtmp.youtube.com/live2/${STREAM_KEY}"

echo "Stream finished after 4 hours."
