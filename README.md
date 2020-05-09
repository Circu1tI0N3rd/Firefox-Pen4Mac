# Firefox-Pen4Mac
An Applescript solution for a "decent enough" Firefox portability on macOS


## Known limitations:
- Firefox still put some crash logs and such into your Library folder but not your profiles!
- I did not cover most of the errors that can happen during the script execution.

## Usage:
Clone this repo or download the .zip file in _releases_ section, then run the included application.

The application will ask you if it can __automatically download the latest Firefox__ directly from Mozilla server using _**cURL**_.
If you don't want to wait for download to complete and you've already had Firefox in your __"/Application"__ folder, you can copy it to __*Firefox-Pen4Mac.app/Contents/Resources*__, just __make sure the Firefox application named *"Firefox.app"*, otherwise the script will ask you to download it!__

The app will also ask you if it can create a new profile for you if none exists (or you just run the downloaded app without any modifications).
If you want to add your existing profile(s), just copy the profile folder(s) to __*Firefox-Pen4Mac.app/Contents/Resources/Profiles*__. You can copy as many as you want, since it will let you pick if multiple were found.

## Repackaging the application:
If somehow the app I posted here not working (aka Catalina refused to run it), or you just tinkering the source code *(the ".applescript" file)*, you can recreate the application from the *".applescript" (or ".scpt")* file from Script Editor directly. SEARCH THE GOOGLE FOR IT!

## License:
NO LICENSE!
