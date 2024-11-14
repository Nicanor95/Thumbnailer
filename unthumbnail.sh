#!/bin/bash
# Removes thumbnails from mp4 files.

for FILE in *.mp4; do
	NEWFILE=${FILE/.mp4/-clean.mp4}
	echo "$FILE -> $NEWFILE"
	AtomicParsley "$FILE" --artwork REMOVE_ALL --output "$NEWFILE"
done