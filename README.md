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

## FAQ:
#### Q: I can't see the "Profiles" folder anywhere inside *Firefox-Portable4Mac.app/Contents/Resources*. Where is it?
##### A: The folder will be automatically created when starting the application. If you need to use your own profile(s), just create that "Profiles" folder in *Firefox-Portable4Mac.app/Contents/Resources* and copy your profile into it.

## Acknowledgement:
- Apple for many scripts and tools
- Mozilla for Firefox and its command line features
- And [Erik's Lab](https://erikslab.com) for a [function](https://erikslab.com/2007/08/31/applescript-how-to-split-a-string/) that is extremely useful
