on run
	set extension to changeCaseOfText((item 2 of splitText((name of (info for (path to me)) as text), ".")), "lower")
	if extension is equal to "scpt" then
		set cwd to POSIX path of ((path to me as text) & "::")
	else if extension is equal to "app" then
		set cwd to ((POSIX path of (path to me as text)) & "Contents/Resources/")
	else
		display alert "Illegal file/folder type! This is not what I'm anticipated!"
		return 1
	end if
	if checkexists(cwd, "Firefox.app") is equal to "File" then do shell script "rm -f \"" & cwd & "Firefox.app\""
	if checkexists(cwd, "Firefox.app") is false then
		display dialog "Firefox.app does not exists!
Do you want to download Firefox?" buttons {"Yes", "No"}
		if (button returned in result) is equal to "No" then return 0
		set fileURL to do shell script "curl -Is https://download.mozilla.org/\\?product\\=firefox-latest-ssl\\&os\\=osx\\&lang\\=en-US | sed -n \"s/Location: //p\" | sed \"s/\\.dmg/\\.pkg/\""
		tell me to display notification "Downloading Firefox package..." sound name "Morse" with title "Firefox Portable for macOS"
		delay 1
		do shell script ("curl -#o \"" & cwd & "Firefox.pkg\" " & fileURL)
		tell me to display notification "Download completed!
Extracting..." sound name "Morse" with title "Firefox Portable for macOS"
		delay 1
		do shell script "cd \"" & cwd & "\" && tar -xf Firefox.pkg Payload &>/dev/null && rm Firefox.pkg &>/dev/null && cat Payload | gunzip -dc | cpio -i &>/dev/null && rm Payload &>/dev/null"
		tell me to display notification "Download Firefox completed!" sound name "Tri-tone" with title "Firefox Portable for macOS"
		delay 1
	end if
	if checkexists(cwd, "Profiles") is equal to "Folder" then
		set profiles to getprofiles(cwd & "Profiles/")
		if number of items in profiles is greater than 1 then
			choose from list profiles with prompt "Multiple profiles found. Select one to launch:"
			set profile to result
			if profile is false then return 0
		else if number of items in profiles is equal to 0 then
			display dialog "No profile exists! Create a new one?" buttons {"Yes", "No"}
			if (button returned in result) is equal to "No" then return 0
			set profile to (randomText(15) & ".portable")
		else
			set profile to item 1 of profiles
		end if
	else
		if checkexists(cwd, "Profiles") is equal to "File" then do shell script "rm -f \"" & cwd & "Profiles\""
		do shell script ("mkdir \"" & cwd & "Profiles\"")
		display dialog "No profile exists! Create a new one?" buttons {"Yes", "No"}
		if (button returned in result) is equal to "No" then return 0
		set profile to (randomText(15) & ".portable")
	end if
	if checkexists(cwd, "profLock") is equal to "File" then do shell script "rm -f \"" & cwd & "profLock\""
	if checkexists(cwd, "profLock") is false then do shell script ("mkdir \"" & cwd & "profLock\"")
	if checkexists(cwd, "Logs") is equal to "File" then do shell script "rm -f \"" & cwd & "Logs\""
	if checkexists(cwd, "Logs") is false then do shell script ("mkdir \"" & cwd & "Logs\"")
	runbackground(cwd, profile)
	return 0
end run


on runbackground(location, profile)
	set lockstate to checkexists(location & "profLock/", profile & ".lock")
	if lockstate is equal to "File" then
		set fin to open for access (location & "profLock/" & profile & ".lock")
		set proc to getProc(read fin as text)
		close access fin
		if proc is false then
			do shell script "rm -f \"" & location & "profLock/" & profile & ".lock\""
			set state to "dead"
		else
			tell proc
				activate
				set the frontmost of it to true
			end tell
			set state to "running"
			return
		end if
	else
		if lockstate is equal to "Folder" then do shell script "rm -rf \"" & location & "profLock/" & profile & ".lock\""
		set state to "dead"
	end if
	if state is equal to "dead" then
		set pid to do shell script ("HOME=\"" & location & "\" PWD=\"" & location & "\" \"" & location & "Firefox.app/Contents/MacOS/firefox-bin\" --new-instance --profile \"" & location & "Profiles/" & profile & "\" --MOZ_LOG_FILE=\"" & location & "Logs/firefox." & profile & "\" &> /dev/null & echo $!")
		set fout to open for access (location & "profLock/" & profile & ".lock") with write permission
		write pid as text to fout
		close access fout
		return
	end if
end runbackground

on getProc(pid)
	tell application "System Events"
		set procs to every process whose unix id is pid
		if (number of items in procs) is less than 1 then return false
		return item 1 of procs
	end tell
end getProc

on checkexists(location, fileorfolder)
	repeat with entry in (list folder of location without invisibles)
		if (entry as text) is equal to (fileorfolder as text) then
			if (folder of (info for (location & entry))) is true then
				return "Folder"
			else
				return "File"
			end if
		end if
	end repeat
	return false
end checkexists

on getprofiles(location)
	set profiles to {}
	set i to 1
	repeat with entry in (list folder of location without invisibles)
		if (location & (POSIX path of entry)) is not file then
			set profiles to insertItemInList(entry, profiles, i)
			set i to i + 1
		end if
	end repeat
	return profiles
end getprofiles

on randomText(len)
	set charlist to {"a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0"}
	set caselist to {"upper", "lower"}
	set answer to ""
	repeat with position from 1 to len
		set answer to (answer & changeCaseOfText((item (random number from 1 to (number of items of charlist)) of charlist), (item (random number from 1 to 2) of caselist)))
	end repeat
	return answer
end randomText


--Courtesy of developer.apple.com
on insertItemInList(theItem, theList, thePosition)
	set theListCount to length of theList
	if thePosition is 0 then
		return false
	else if thePosition is less than 0 then
		if (thePosition * -1) is greater than theListCount + 1 then return false
	else
		if thePosition is greater than theListCount + 1 then return false
	end if
	if thePosition is less than 0 then
		if (thePosition * -1) is theListCount + 1 then
			set beginning of theList to theItem
		else
			set theList to reverse of theList
			set thePosition to (thePosition * -1)
			if thePosition is 1 then
				set beginning of theList to theItem
			else if thePosition is (theListCount + 1) then
				set end of theList to theItem
			else
				set theList to (items 1 thru (thePosition - 1) of theList) & theItem & (items thePosition thru -1 of theList)
			end if
			set theList to reverse of theList
		end if
	else
		if thePosition is 1 then
			set beginning of theList to theItem
		else if thePosition is (theListCount + 1) then
			set end of theList to theItem
		else
			set theList to (items 1 thru (thePosition - 1) of theList) & theItem & (items thePosition thru -1 of theList)
		end if
	end if
	return theList
end insertItemInList

on changeCaseOfText(theText, theCaseToSwitchTo)
	if theCaseToSwitchTo contains "lower" then
		set theComparisonCharacters to "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
		set theSourceCharacters to "abcdefghijklmnopqrstuvwxyz"
	else if theCaseToSwitchTo contains "upper" then
		set theComparisonCharacters to "abcdefghijklmnopqrstuvwxyz"
		set theSourceCharacters to "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
	else
		return theText
	end if
	set theAlteredText to ""
	repeat with aCharacter in theText
		set theOffset to offset of aCharacter in theComparisonCharacters
		if theOffset is not 0 then
			set theAlteredText to (theAlteredText & character theOffset of theSourceCharacters) as string
		else
			set theAlteredText to (theAlteredText & aCharacter) as string
		end if
	end repeat
	return theAlteredText
end changeCaseOfText


--Courtesy of Erik's Lab: https://erikslab.com/2007/08/31/applescript-how-to-split-a-string/
on splitText(theString, theDelimiter)
	set oldDelimiters to AppleScript's text item delimiters
	set AppleScript's text item delimiters to theDelimiter
	set theArray to every text item of theString
	set AppleScript's text item delimiters to oldDelimiters
	return theArray
end splitText