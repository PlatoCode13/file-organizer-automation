# 🗂️ My Little Download Folder Helper

Okay, so, my Downloads folder... it was a *mess*.  Seriously, a digital disaster zone.  PDFs wrestling with images, videos staging a coup against installers... you know the drill.  I figured there had to be a better way.  And honestly, I mostly built this for myself, but maybe it can help you too?

This is a super simple Bash script that tries to organize your Downloads folder.  It's nothing fancy, but it does a decent job of sorting things into categories.  Think of it as a tiny digital assistant, gently nudging files into their proper places.

## How It Works

The script looks at the file type and, if it can, checks for metadata (like creation dates for images/videos or titles for music).  Then, it moves the files into folders.  Here's the breakdown:

*   **Images:** `.jpg`, `.jpeg`, `.png`, `.gif`, `.webp` go to the `Images` folder.
*   **Videos:** `.mp4`, `.mov`, `.avi`, `.mkv`, `.webm` head to `Videos`.
*   **Music:** `.mp3`, `.flac`, `.wav`, `.ogg` jam out in `Music`.
*   **Documents:** `.pdf` files are filed away in `Documents`.
*   **Other:** Anything else gets sent to the `Other` folder.

## How to Use

1.  **Save:** Save the `organize_files.sh` script somewhere on your system.
2.  **Permissions:** Make it executable: `chmod +x organize_files.sh`.
3.  **Run:** `./organize_files.sh` in your terminal.

## Dependencies

*   You'll need `exiftool` for metadata: `sudo apt-get install libimage-exiftool` (or the equivalent for your Linux flavor).
*   And `pdfinfo` for PDFs: `sudo apt-get install poppler-utils` (or similar).

## Configuration

The `DOWNLOAD_DIR`, `ORGANIZED_DIR`, and `LOG_FILE` variables at the top of the script let you change where things go and where the log file is saved.

## Test Script

There's a `create_test_files.sh` script to make some dummy files so you can test without risking your real files.

## Log File

The script keeps a log at `$HOME/Organized/organizer.log`.  It's helpful for seeing what happened and if anything went wrong.

## Contributing

If you have ideas on how to make it better, please feel free to contribute!  I'm always open to suggestions.

