<#
mkvdts3ac3

This script removes the DTS track from a MKV file and replaces it with an AC3 track in folders recursively.
See README.txt on how to configure and run

#>

# Set location of of mkvtoolnix and ffmpeg executables
$mkvinfo = ""
$mkvmerge = ""
$mkvextract = ""
$ffmpeg = ""


# Write header text
Write-Host "-----------------------------------"
Write-Host "mkvdts2ac3 powershell script v1.10"
Write-Host "-----------------------------------"
Write-Host ""

# Get the name of the mkv file to process - %1 holds the directory containing downloaded files passed from Sabnzbd
$jobpath = $args[0]
Write-Host "Source directory argument:" $jobpath

# Find the mkv files we have left
$mkvfiles = Get-ChildItem -Path $jobpath -Filter *.mkv -Recurse -File | % { $_.FullName }
Write-Host ("Following MKV files were found (Total count: {0})" -f $mkvfiles.Count)
foreach ($mkvfile in $mkvfiles) 
{ 
	# We are going to process this file so output some info
	$file = get-item $mkvfile
	
	Write-Host "  Working on " $file.Name 

	if ($mkvfile -eq "")
	{
		#No mkv file to process
		Write-Host "    No MKV file to process"
		Continue
	}

	# Check if the file already has an AC3 track
	if  (Invoke-Expression -Command "& `"$mkvmerge`" -i `"$mkvfile`"" | Select-String "AC-3" -quiet)
	{ 
		Write-Host "    An AC3 track already exists in this file" 
		Continue
	}
	
	#Find the track number of our DTS stream in the MKV file
	$dtstrack = Invoke-Expression -Command "& `"$mkvmerge`" -i `"$mkvfile`"" | Select-String "A_DTS" | Out-String
	if ($dtstrack -eq "")
	{ 
		$dtstrack = Invoke-Expression -Command "& `"$mkvmerge`" -i `"$mkvfile`"" | Select-String "DTS-HD" | Out-String
		if ($dtstrack -eq "")
		{ 
			Write-Host "    A DTS track could not be found in the source MKV file"
			Continue
		} 
	}
	
	#Get the track id of the video track in original file
	$videotrack = Invoke-Expression -Command "& `"$mkvmerge`" -i `"$mkvfile`"" | Select-String "video " | Out-String 
	if ($videotrack -eq "")
	{ 
		Write-Host "    A video track could not be found in the source MKV file"
		Continue
	}  

	$wd = $($file.Directory)
	$oldmkvfile = $($file.Name)
	$dtsfile =  $($file.BaseName + ".dts")
	$ac3file = $($file.BaseName + ".ac3")
	$tcfile = $($file.BaseName + ".tc")
	$newmkvfile = $($file.BaseName + ".new.mkv")

	#Write-Host "    Directory: " $wd
	#Write-Host "    MKV File: " $oldmkvfile
	#Write-Host "    DTS File: " $dtsfile
	#Write-Host "    AC3 File:" $ac3file
	#Write-Host "    TC File:  " $tcfile
	#Write-Host "    New File: " $newmkvfile
	
	$dtstrack = $dtstrack.split(' ')[2].replace(":", "")  # Finds the third field which is track number then ditches the colon char
	Write-Host "    DTS track:" $dtstrack
		
	$videotrack = $videotrack.split(' ')[2].replace(":", "")  # Finds the third field which is track number then ditches the colon char
	Write-Host "Video track:" $videotrack
	
	#Extract the timecodes file
	Write-Host "    Extracting timecodes from MKV file"
	Invoke-Expression -Command "& `"$mkvextract`" timecodes_v2 `"$mkvfile`" $dtstrack`:`"$wd\$tcfile`""
	
	if ($LastExitCode -ne 0)
	{
		Write-Host "    Could not extract the timecodes from the source MKV file"
		Continue
	}
	#Get the audio delay value from the timecodes file (its the value in 2nd line of the file)
	$tc = Get-Content $("$wd\$tcfile") -TotalCount 2   #read first 2 lines of the file
	$audiodelay = $tc[1]   #the delay value is 2nd line of the file
	Write-Host ("    Audio delay of {0}ms in source MKV file" -f $audiodelay)
				
	#Extract the DTS file
	Write-Host ("    Extracting the DTS audio track")
	Invoke-Expression -Command "& `"$mkvextract`" tracks `"$mkvfile`" $dtstrack`:`"$wd\$dtsfile`""
	if ($LastExitCode -ne 0)
	{
		Write-Host "    Could not extract the DTS track from the source MKV file"
		Continue
	}
	
	
	#Convert the DTS file to AC3
	Write-Host ("    Converting DTS audio to AC3")
	Invoke-Expression -Command "& `"$ffmpeg`" -i `"$wd\$dtsfile`" -acodec ac3 -ac 6 -ab 448k `"$wd\$ac3file`""
	if ($LastExitCode -ne 0)
	{
		Write-Host "    Could not convert the DTS track to AC3 format"
		Continue
	}
	
	
	#Start to build the mkvmerge command to mux our streams together
	$CMD = "`"$mkvmerge`""
	$CMD = $($CMD + " --track-order 0:1,1:0")   #puts new AC3 track as second track.
	$CMD = $($CMD + " -o " + "`"$wd\$newmkvfile`"")   #Specify output filename
	#$CMD = $($CMD + " -A")   #Drop all existing audio tracks
	$CMD = $($CMD + " --compression " + $videotrack + ":none")   #Get rif of header compression as it doesn't play on XBOX
	$CMD = $($CMD + " `"$mkvfile`"")   #Provide source mkv file (original one)
	$CMD = $($CMD + " --sync 0:$audiodelay")  #add any audio delay that was in original file
	$CMD = $($CMD + " --compression 0:none")
	$CMD = $($CMD + " --default-track 0")   #new AC3 track as default.
	$CMD = $($CMD + " --language 0:eng")   #set language to english.
	$CMD = $($CMD + " `"$wd\$ac3file`"")   #Specify the ac3 file to mux in
	
	# Mux it !
	Write-Host "    Muxing the streams together with the following command:"
	Write-Host $CMD
	Invoke-Expression -Command "& $CMD"
	if ($LastExitCode -ne 0)
	{
		Write-Host "    Could not mux the new MKV file"
		Continue
	}
	
	# Tidy up
	Write-Host "    Removing temp files and renaming new MKV file to original name"
	Remove-Item $("$wd\$dtsfile")
	Remove-Item $("$wd\$tcfile")
	Remove-Item $("$wd\$ac3file")
	Remove-Item $("$wd\$oldmkvfile")
	Rename-Item $("$wd\$newmkvfile") -NewName $("$wd\$oldmkvfile")
}
Write-Host "mkvdts2ac3 processing completed successfully"
Exit 0
