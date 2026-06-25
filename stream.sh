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
download_video "https://www.dropbox.com/scl/fi/2mxnozhxa5xlea1pp79bz/2026-06-26-02.17.50.mp4?rlkey=dql7cwhf6oykw5z8wmr992dd1&st=2p9si5l3&dl=1"
download_video "https://www.dropbox.com/scl/fi/2mxnozhxa5xlea1pp79bz/2026-06-26-02.17.50.mp4?rlkey=dql7cwhf6oykw5z8wmr992dd1&st=nkh7n8us&dl=1"
download_video "https://www.dropbox.com/scl/fi/umvowawsbagjor9ujvq68/2026-06-26-02.35.32.mp4?rlkey=jmi8jgoca1nydz99kdii39p7c&st=rsi1kgva&dl=1"
download_video "https://www.dropbox.com/scl/fi/umvowawsbagjor9ujvq68/2026-06-26-02.35.32.mp4?rlkey=jmi8jgoca1nydz99kdii39p7c&st=i4zbwvsq&dl=1"

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
