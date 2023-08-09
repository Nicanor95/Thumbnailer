#!/bin/bash
# removes certain characters from filenames that Windows does
# not like.

for FILE in *.mp4; do
	NEW_NAME=$(sed "s/'//g;s/\[//g;s/\]//g;s/,//g" <<< "$FILE")
	mv "$FILE" "$NEW_NAME"
	echo "$FILE --> $NEW_NAME"
done