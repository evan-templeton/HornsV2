# Horns+ Setup

## 1. CocoaPods Setup

[Install CocoaPods](https://guides.cocoapods.org/using/getting-started.html)

After installing CocoaPods, and with Xcode closed, open a terminal, navigate to the project directory, and run `pod init`.

Open the newly created `Podfile` and paste the following text under `#Pods for HornsV2`:

pod 'Firebase/Auth'
pod 'Firebase/Firestore'
pod 'FirebaseStorage', '~> 8.5'
pod 'CLTypingLabel', '~> 0.4'
pod 'SDWebImage', '~> 5.11'
pod 'IQKeyboardManagerSwift', '~> 6.5'
pod 'GooglePlaces', '~> 5.0'

Save the file (cmd + S), close Xcode/textEdit, then back in your terminal (in the project directory) run `pod install`.

Once all the Pods are finished installing, feel free to close the terminal. Then open Xcode and open the new `HornsV2.xcworkspace` file.

General note: you'll always want to open the .xcworkspace file (as opposed to the original .xcodeproj file) when using CocoaPods.
