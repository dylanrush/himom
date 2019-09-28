#!/bin/bash

cd /home/pi/led-matrix-cloud-display
while :
do
  sudo matrix/utils/led-image-viewer --led-rows=16 load.png &
  ID=$!
  rm manifest*
  wget "https://your-s3-bucket.s3.amazonaws.com/manifest"
  if [[ $(diff manifest current-manifest) ]]
  then
    rm -rf images/*
    while read fn; do
      echo "$fn"
      wget "https://your-s3-bucket.s3.amazonaws.com/$fn" -O "images/$fn"
    done < manifest
  fi
  cp manifest current-manifest
  sleep 1
  ps aux | grep $ID
  echo $ID
  sudo kill -9 $ID
  sudo killall -u daemon
  sudo matrix/utils/led-image-viewer  --led-rows=16 -f -w 20 images/* &
  ID=$!
  sleep 3600
  sudo kill -9 $ID
  sudo killall -u daemon
done

