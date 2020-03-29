#`mkvdts2ac3`

A Powershell based script for Windows users which can be used for converting the DTS audio track in a MKV (Matroska) files to AC3. This will convert all MKV files applicable under the given directory. It will search folders recursively.

Inspired by Jack Wharton's linux version available [here] (https://github.com/JakeWharton/mkvdts2ac3).
Forked from Derek Robertson's Powershell version (https://github.com/derekrobertson/mkvdts2ac3)

##Pre-requisites
Note: This script was developed on a machine running Powershell v3 although v2 should work fine as well.

  1. [Powershell](http://download.microsoft.com) - Microsoft Powershell.
  2. [mkvtoolnix](http://www.bunkus.org/videotools/mkvtoolnix/) - mkvtoolnix tools by Bunkus.
  3. [ffmpeg](http://ffmpeg.zeranoe.com/builds/) - Static windows build of ffmpeg.
  
##Installation

  1. Download the package from github and place into a directory of your choice.
  2. Edit `mkvdts2ac3.ps1` script and update the locations of the `mkvtoolnix` and `ffmpeg` executable files at the start of the script.   
##Running
  From windows command prompt enter command:

    <script-directory>\mkvdts2ac3.ps1 "<video-directory>"

  Eg.
  
    D:\scripts\mkvdts2ac3.ps1 "D:\my videos\video1"

  The script will run and the DTS track in MKV files will be converted to AC3.

##Acknowledgements
Jake Wharton - for the original linux based version of mkvdts2ac3 available [here] (https://github.com/JakeWharton/mkvdts2ac3).
Derek Robertson - for the original windows version of mkvdts2ac3 [derek.robertson.uk@gmail.com] (mailto:derek.robertson.uk@gmail.com)
