#!/bin/bash

#FILTERS=("thumbs.db" "desktop.ini" "picasa.ini" "Folder.jpg" "album_art" "._*" ".DS_Store")
find . -empty -type d -delete
find . -name "Thumbs.db" -print0 | xargs -0 rm -rf
find . -name ".picasa.ini" -print0 | xargs -0 rm -rf
find . -name ".DS_Store" -print0 | xargs -0 rm -rf
find . -name "._*" -print0 | xargs -0 rm -rf

# Remove empty directories
find . -type d -empty -exec rmdir {} \;

