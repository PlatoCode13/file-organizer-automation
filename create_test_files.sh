#!/bin/bash

# Test Script for File Organizer

# Create test files and directories
mkdir -p "$HOME/Downloads/test_files"
mkdir -p "$HOME/Downloads/test_files/images"
mkdir -p "$HOME/Downloads/test_files/videos"
mkdir -p "$HOME/Downloads/test_files/music"
mkdir -p "$HOME/Downloads/test_files/documents"
mkdir -p "$HOME/Downloads/test_files/other"

# Create test files
touch "$HOME/Downloads/test_files/images/image1.jpg"
touch "$HOME/Downloads/test_files/images/image2.png"
touch "$HOME/Downloads/test_files/videos/video1.mp4"
touch "$HOME/Downloads/test_files/videos/video2.mov"
touch "$HOME/Downloads/test_files/music/music1.mp3"
touch "$HOME/Downloads/test_files/music/music2.flac"
touch "$HOME/Downloads/test_files/documents/document1.pdf"
touch "$HOME/Downloads/test_files/documents/document2.txt" # Will go to "Other"
touch "$HOME/Downloads/test_files/other/file with spaces.txt"
touch "$HOME/Downloads/test_files/broken_symlink" # Create a broken symlink
ln -s /nonexistent/file "$HOME/Downloads/test_files/broken_symlink"

# Add some metadata (you might need to install exiftool: `sudo apt-get install libimage-exiftool` or equivalent)
exiftool -CreateDate="2024:07:20 10:00:00" "$HOME/Downloads/test_files/images/image1.jpg"
exiftool -CreateDate="2024:07:21 12:00:00" "$HOME/Downloads/test_files/videos/video1.mp4"
exiftool -Title
exiftool -Title="Test Music" "$HOME/Downloads/test_files/music/music1.mp3" 2>/dev/null

# Run the file organizer script (CORRECT PATH HERE!)
./organize_files.sh  # <--- Corrected path

# Check the organized directory (AFTER running the organize_files.sh script)
ls -l "$HOME/Organized/Images"
ls -l "$HOME/Organized/Videos"
ls -l "$HOME/Organized/Music"
ls -l "$HOME/Organized/Documents"
ls -l "$HOME/Organized/Other"

# Display the log file (AFTER running the organize_files.sh script)
cat "$HOME/Organized/organizer.log"


# Cleanup (optional - comment out if you want to keep the files for inspection)
# rm -rf "$HOME/Downloads/test_files"   # Comment these out until you are sure it's working.
# rm -rf "$HOME/Organized"
