#!/bin/bash

# This will only work on a unix-based system with imagemagick installed!

# Your file structure should look like this:
# |
# |-some-image-filename-1.jpg         an image to process
# |-some-other-image-.jpg             an image to process
# |-maybe-even-a-third-image.jpg      an image to process
# |-after/                            Directory for watermarked images
# |-before/                           Directory for backing up images
# |-logos/                            Directory for logos
#    +-logo.png                       Full size logo with transparency
# |-bay.sh                            This script


# Loop through the files
for file in ./*.jpg;
do
  echo "processing $file ..."

  # Get the width of the image to watermark
  size=$(identify -format "%w" $file)

  # Calculate the size you want the watermark to be based on the image size
  wmsize=$(expr $size / 3)

  # Remove any existing watermark logo file and create a new one at the optimal size
  rm logos/sm.png
  convert logos/logo.png -resize ${wmsize}x${wmsize} ./logos/sm.png

  # Save a backup
  cp $file ./before/

  # Watermark the image and save the new copy to the "after" folder
  newPath="./after/"
  newFile=${file/.\//$newPath}
  echo "Saving to $newFile"
  composite -gravity southeast -geometry +10+10 -dissolve 50% ./logos/sm.png $file $newFile
  rm -f $file
done
