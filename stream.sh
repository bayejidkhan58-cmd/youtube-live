#!/bin/bash
set -e

download_video() {
  local url="$1"
  local output="$2"
  echo "Downloading $output..."
  wget -q -O "$output" "$url"

  # Check if file exists and is a valid video (not an HTML error page)
  if [ ! -s "$output" ]; then
    echo "ERROR: $output is empty or failed to download."
    exit 1
  fi

  filetype=$(file -b "$output")
  if [[ "$filetype" != *"ISO Media"* && "$filetype" != *"MP4"* && "$filetype" != *"data"* ]]; then
    echo "ERROR: $output is not a valid video file. Got: $filetype"
    echo "Check if the Dropbox link is correct and not expired."
    exit 1
  fi

  echo "$output downloaded successfully ($(du -h "$output" | cut -f1))"
}

# Download all videos with validation
download_video "https://www.dropbox.com/scl/fi/xxxxx/v1.mp4?dl=1" "v1.mp4"
download_video "https://www.dropbox.com/scl/fi/xxxxx/v2.mp4?dl=1" "v2.mp4"
download_video "https://www.dropbox.com/scl/fi/xxxxx/v3.mp4?dl=1" "v3.mp4"
download_video "https://www.dropbox.com/scl/fi/xxxxx/v4.mp4?dl=1" "v4.mp4"

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
