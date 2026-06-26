#!/bin/bash
set -e

download_video() {
  local url="$1"
  local output="$2"
  echo "Downloading $output..."
  wget -q -O "$output" "$url"

  if [ ! -s "$output" ]; then
    echo "ERROR: $output is empty or failed to download."
    exit 1
  fi

  filetype=$(file -b "$output")
  if [[ "$filetype" != *"ISO Media"* && "$filetype" != *"MP4"* && "$filetype" != *"data"* ]]; then
    echo "ERROR: $output is not a valid video file. Got: $filetype"
    exit 1
  fi

  echo "$output downloaded successfully ($(du -h "$output" | cut -f1))"
}

download_video "https://www.dropbox.com/scl/fi/ipz6w8ilnjes4tqf6y9ex/2026-06-25-21.06.04.mp4?rlkey=y3atgrzto4erl6ljw3es14263&st=1ftbd407&dl=1" "v1.mp4"
download_video "https://www.dropbox.com/scl/fi/2pdqf4qptbpxnudcoecfi/2026-06-26-02.09.13.mp4?rlkey=4ytyjwymh8plaarf53tjedsx4&st=89yls3us&dl=1" "v2.mp4"
download_video "https://www.dropbox.com/scl/fi/2mxnozhxa5xlea1pp79bz/2026-06-26-02.17.50.mp4?rlkey=dql7cwhf6oykw5z8wmr992dd1&st=rhdavt4l&dl=1" "v3.mp4"
download_video "https://www.dropbox.com/scl/fi/umvowawsbagjor9ujvq68/2026-06-26-02.35.32.mp4?rlkey=jmi8jgoca1nydz99kdii39p7c&st=5lidxnyi&dl=1" "v4.mp4"

echo "file 'v1.mp4'
file 'v2.mp4'
file 'v3.mp4'
file 'v4.mp4'" > playlist.txt

echo "Starting Shorts-ready vertical stream for 4 hours..."
timeout 14400 ffmpeg -re -stream_loop -1 -f concat -safe 0 -i playlist.txt \
  -vf "scale=1080:1920:force_original_aspect_ratio=decrease,pad=1080:1920:(ow-iw)/2:(oh-ih)/2" \
  -c:v libx264 -preset veryfast \
  -b:v 2800k -maxrate 3000k -bufsize 6000k \
  -g 48 -keyint_min 48 \
  -c:a aac -b:a 128k -ar 44100 \
  -f flv "rtmp://a.rtmp.youtube.com/live2/${STREAM_KEY}"

echo "Stream finished after 4 hours."
