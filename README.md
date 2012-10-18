#`mkvdts2ac3`

A Powershell based script for Windows users which can be used for converting the DTS audio track in a MKV (Matroska) file to AC3.

Inspired by Jack Wharton's linux version available [here] (https://github.com/JakeWharton/mkvdts2ac3).


##Pre-requisites
Note: This script was developed on a machine running Powershell v3 although v2 should work fine as well.

  1. [Powershell](http://download.microsoft.com) - Microsoft Powershell.
  2. [mkvtoolnix](http://www.bunkus.org/videotools/mkvtoolnix/) - mkvtoolnix tools by Bunkus.
  3. [ffmpeg](http://ffmpeg.zeranoe.com/builds/) - Static windows build of ffmpeg.
  
  *Note: Next pre-req is only required if you are using CouchPotato for automation.*
  4. [sabToCouchPotato] (https://couchpota.to/forum/showthread.php?tid=343) - Post processing script for Sabnzbd+ by clinton.hall.

##Installation

  1. Download the package from github and place into a directory of your choice.
  2. Edit `mkvdts2ac3.ps1` script and update the locations of the `mkvtoolnix` and `ffmpeg` executable files at the start of the script.   

**Next steps required if you are using as a post-processing script with Sabnzbd+ (no CouchPotato):**
  1. Edit `mkvdts2ac3.cmd` script and change the value of USECOUCHPOTATO to 0 - eg. `USECOUCHPOTATO=0`
  2. Edit `mkvdts2ac3.cmd` script and update the location on your system of the `mkvdts2ac3.ps1` file.
  3. Set post-processing script for your movies category to `mkvdts2ac3.cmd`

**Next steps required if you are using as a post-processing script with Sabnzbd+ AND using CouchPotato:**
  1. Edit `mkvdts2ac3.cmd` script and change the value of USECOUCHPOTATO to 1 - eg. `USECOUCHPOTATO=1`
  2. Install and configure `sabToCouchPotato.exe` post-processing script as per instructions on the linked url in Pre-reqs section.
  3. Edit `mkvdts2ac3.cmd` script and update the location on your system of the `mkvdts2ac3.ps1` file and the `sabToCouchPotato.exe` file.
  4. Set post-processing script for your movies category to `mkvdts2ac3.cmd`

##Running Manually
  From windows command prompt enter command:

    <script-directory>\mkvdts2ac3.cmd "path-to-mkv-file"

  Eg.
  
    D:\scripts\mkvdts2ac3.cmd "D:\my videos\video1.mkv"

  The script will run and the DTS track in the MKV file will be converted to AC3.

##Running as a post processing script for Sabnzbd+
  Configure a category for your downloads with the post-processing script set to `mkvdts2ac3.cmd`

  * Notes - Using this configuration will allow:
     * Sabnzbd+ to download, check, repair and unpack the files
     * mkvdts2ac3 to convert any DTS track to AC3

##Running as a post processing script for Sabnzbd+ with CouchPotato
  1. In CouchPotato, goto *Settings* and then *Renamer*.
  2. Configure the renamer as you wish but ensure that the value for *Run Every* is set to zero (important!).
  3. In Sabnzbd+ find the category that CouchPotato uses and configure the post-processing script as `mkvdts2ac3.cmd`

  * Notes - Using this configuration will allow:
     * Sabnzbd+ to download, check, repair and unpack the files  
     * mkvdts2ac3 to convert any DTS track to AC3  
     * mkvdts2ac3 will then call sabToCouchPotato.exe to fire CouchPotato's renamer process for that download  
  
##Developed by
Derek Robertson - [derek.robertson.uk@gmail.com] (mailto:derek.robertson.uk@gmail.com)

##Acknowledgements
Jake Wharton - for the original linux based version of mkvdts2ac3 available [here] (https://github.com/JakeWharton/mkvdts2ac3).

##License
>Copyright 2012 - Derek Robertson  
>  
>Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

>   http://www.apache.org/licenses/LICENSE-2.0

>Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
