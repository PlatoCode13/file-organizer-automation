#!/bin/bash

# Automated File & Media Organizer

# --- Configuration ---
DOWNLOAD_DIR="$HOME/Downloads"
ORGANIZED_DIR="$HOME/Organized"
LOG_FILE="$ORGANIZED_DIR/organizer.log"

# Create organized directories (if they don't exist)
mkdir -p "$ORGANIZED_DIR/Images" "$ORGANIZED_DIR/Videos" "$ORGANIZED_DIR/Music" "$ORGANIZED_DIR/Documents" "$ORGANIZED_DIR/Other"

# --- Logging Function ---
log_message() {
  timestamp=$(date +"%Y-%m-%d %H:%M:%S")
  severity="$1"  # "INFO", "WARNING", "ERROR"
  message="$2"
  echo "[$timestamp] [$severity] $message" >> "$LOG_FILE"
}

# --- File Organization Function ---
organize_file() {
  file="$1"
  filename=$(basename "$file")
  extension="${filename##*.}"; extension="${extension,,}" # Extract extension and convert to lowercase

  log_message "INFO" "Processing: '$filename'"

  # Check if the file is readable
  if [[ ! -r "$file" ]]; then
    log_message "ERROR" "File '$filename' is not readable. Skipping."
    return 1  # Indicate failure
  fi

  target_dir=""

  # --- File Type and Metadata Handling ---
  case "$extension" in
    jpg|jpeg|png|gif|webp)
      create_date=$(exiftool -s -r -CreateDate "$file" 2>/dev/null | awk -F': ' '{print $2}')
      if [[ -n "$create_date" ]]; then
        target_dir="$ORGANIZED_DIR/Images"
        log_message "INFO" "Image metadata found (CreateDate: $create_date)."
      else
        target_dir="$ORGANIZED_DIR/Images"
        log_message "INFO" "No image metadata (CreateDate) found. Using default Image folder."
      fi
      ;;

    mp4|mov|avi|mkv|webm)
      create_date=$(exiftool -s -r -CreateDate "$file" 2>/dev/null | awk -F': ' '{print $2}')
      if [[ -n "$create_date" ]]; then
        target_dir="$ORGANIZED_DIR/Videos"
        log_message "INFO" "Video metadata found (CreateDate: $create_date)."
      else
        target_dir="$ORGANIZED_DIR/Videos"
        log_message "INFO" "No video metadata (CreateDate) found. Using default Video folder."
      fi
      ;;

    mp3|flac|wav|ogg)
      title=$(exiftool -s -r -Title "$file" 2>/dev/null)
      if [[ -n "$title" ]]; then
        target_dir="$ORGANIZED_DIR/Music"
        log_message "INFO" "Music metadata found (Title: $title)."
      else
        target_dir="$ORGANIZED_DIR/Music"
        log_message "INFO" "No music metadata (Title) found. Using default Music folder."
      fi
      ;;

    pdf)
      if pdfinfo "$file" > /dev/null 2>&1; then
        target_dir="$ORGANIZED_DIR/Documents"
        log_message "INFO" "PDF metadata available."
      else
        target_dir="$ORGANIZED_DIR/Documents"
        log_message "INFO" "No PDF metadata. Using default Document folder."
      fi
      ;;

    *)  # Default case for other file types
      target_dir="$ORGANIZED_DIR/Other"
      log_message "INFO" "Unknown file type. Moving to 'Other' folder."
      ;;
  esac

  # --- Move the File ---
  if [[ -n "$target_dir" ]]; then
    mv "$file" "$target_dir"  # Move the file
    if [[ $? -eq 0 ]]; then # Check if mv was successful
        log_message "INFO" "Moved '$filename' to '$target_dir'"
    else
        log_message "ERROR" "Failed to move '$filename' to '$target_dir'. Check permissions or disk space."
        return 1 #Indicate failure
    fi
  else
    log_message "ERROR" "Failed to determine target directory for '$filename'"
    return 1 #Indicate failure
  fi
    return 0 #Indicate success
}


# --- Main Script Execution ---
log_message "INFO" "Starting file organization..."

# Find files in the download directory and process them
find "$DOWNLOAD_DIR" -mindepth 1 -print0 | while IFS= read -r -d $'\0' file; do
  organize_file "$file"
done

log_message "INFO" "File organization completed."
