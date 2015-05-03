Microsoft Band SDK Preview README

1. LICENSE

Use of the Microsoft Band SDK is granted under the terms of the license
agreement found at http://go.microsoft.com/fwlink/?LinkID=525147.


2. CONTENTS

The Microsoft Band SDK for iOS package contains the following:

MicrosoftBandKit_iOS.framework – The framework for the Microsoft Bank SDK.

Four sample iOS applications that show how to use the Microsoft Band SDK.
	
	- BandNotification - sending notifications on a Microsoft Band.
	
	- BandCustomPages - sending barcode pages on a Microsoft Band.
	
	- BandPersonalization - updating Me Tile Image on a Microsoft Band.
	
	- BandSensor - subscribing to the accelerometer sensor of a Microsoft Band.

README.txt – this file.


3. PREREQUISITES

The Microsoft Band SDK requires the latest version of the Microsoft Health
application installed, as well as having the Band updated with the latest
firmware (done through the Health application).


4. INSTALLATION INSTRUCTIONS

NOTES: 
	- The minimum supported version of iOS is iOS 7.  
	- The SDK does not support iOS simulator.
	- If you wish to develop an application to communicate with the band in the background,
	  you must enable "Use Bluetooth LE Accessories" in Background Modes.

Steps to include the Microsoft Band SDK framework in your iOS project:
  
	- Open an existing project or create a new project in Xcode.
	- Select your project in the project navigator in Xcode.
	- In the project navigator right click on your project name and select “Add Files to (YourProjectName)”.
	- Locate and select the MicrosoftBandKit framework file and select the option to “Copy items if needed”.
	- Select “Build Phases” under your target.
	- Add “CoreBluetooth.framework” under "Linking Binary with Libraries".


5. KNOWN ISSUES

- When multiple apps are using Microsoft Band, and the Band goes out of range, the connection might not be restored when the Band comes back in range.
In this case, the user needs to force close all the apps using the Microsoft Band.

- PDF417 barcode value string currently only supports numeric digits (0 through 9).


6. SUPPORT AND FEEDBACK

For questions and support use stackoverflow.com with the tag 'microsoft-band'.

For feedback, such as feature requests and bug reports, please send e-mail
to msbandsdk@microsoft.com.