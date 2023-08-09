#!/bin/bash

# Applies thumnails to all .mp4 files in a directory provided by the first argument.
# The thumbnailed files and the thumbnails themselves are saved in the directory of
# the second argument.
# It makes 3 directories inside the directory of the second argument:
#		- thumbs: Here the thumbnails are stored.
#		- vids: Here the thumbnailed videos are stored.
#		- backup: Here the original video files are stored, if desired.
# It wont work with filenames that have certain special characters, before running
# the script, check for special characters.
# I've found until now that it doesn't work with: ' []

if [ -z "$1" ] || [ -z "$2" ]; then
	echo "Missing arguments, usage:"
	echo "thumbnailer <InputDirectory> <OutputDirectory>"
	exit 1
fi

cd "$1"

echo "========================================================================="
echo "Files to thumbnail:"

# Print all files with mp4 extension.
for FILE in *.mp4; do
	echo "$1/$FILE"
done

# Ask user for confirmation
echo "========================================================================="
echo "This script will make 3 directories, one with thumnails, and another to save"
echo "the files thumnailed and a backup one. It won't change the original files."
echo "Do you want to continue? [y/N]"
read CONFIRMATION

if [ $CONFIRMATION == 'y' ] || [ $CONFIRMATION == 'Y' ]; then
	# Make the auxiliary folders
	mkdir -p "$2/thumbs"
	mkdir -p "$2/vids"
	mkdir -p "$2/backup"
	
	# Take a thumbnail and add the thumnbail to the video file, on a separate copy.
	for FILE in *.mp4; do
		echo "File: $FILE"
		LARGO=$(ffprobe -v error -select_streams v:0 -show_entries stream=duration -of default=noprint_wrappers=1:nokey=1 "$FILE")
		LARGO=$(( ${LARGO%%.*} / 4 ))
		ffmpeg -hide_banner -loglevel error -ss $LARGO -i "$FILE" -vframes 1 "$2/thumbs/$FILE.jpg"
		ffmpeg -hide_banner -loglevel error -i "$FILE" -i "$2/thumbs/$FILE.jpg" -map 0 -map 1 -c copy -disposition:v:1 attached_pic "$2/vids/$FILE"
	done
	
	# Ask if user wants to make a backup of the original files.
	echo "========================================================================="
	echo "Do you want to make a backup of the original files? [y/N]"
	read BACKUP
	echo ""
	
	if [ $BACKUP == 'y' ] || [ $BACKUP == 'Y' ]; then
		for FILE in *.mp4; do
			echo "Copying $FILE ..."
			cp "$FILE" "$2/backup/$FILE"
		done
	fi
	
	echo "========================================================================="
	echo "DONE!"
else
	echo "Operation aborted." 
fi
