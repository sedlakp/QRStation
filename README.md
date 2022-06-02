# QR Station app
This app will allow to scan for QR codes and will save them in a list. There will also be a function to create a new QR code and share it. Might also implement points for scanning qr codes  

## Features
* Scan a QR code to get its data (Scan from a camera or an image)
* Create a QR code
* Save scanned or created QR codes
* Detect QR code content
* In case of a link, mail, sms, facetime or youtube video there is a button to open the content hidden in the QR code
* Save or share QR code as an image
* Favorite/Unfavorite or delete QR codes in the list tab
* Add a nickname to QR Code
* Filter QR codes by favorited or by name/text

## Description
* UIKit application
* Instead of storyboards, xib files or SnapKit are used
* MVVM app architecture 
* Some [shape.so](https://shape.so/) icons/images are used within the app
* QR codes are persisted in Realm database


## Resources
* [Use scenes but remove storyboards](https://medium.com/@dpeachesdev/how-to-start-an-ios-app-with-scenedelegate-without-storyboards-f313d70a3710)
* [Setting up xib-controller initialization](https://stackoverflow.com/questions/4763519/loaded-nib-but-the-view-outlet-was-not-set?rq=1)
* [Same topic as above](https://imjhk03.github.io/posts/create-viewcontroller-from-xib/)
* [Observing with Combine](https://cocoacasts.com/combine-fundamentals-observing-a-text-field-with-combine)
* [Table view cell swipe actions](https://programmingwithswift.com/uitableviewcell-swipe-actions-with-swift/)

## Screenshots

Main Screen  
<img src="/screenshots/IMG_6061.png" width="200">

Scanned/created QR code list  
<img src="/screenshots/IMG_6062.png" width="200">

Filtered QR code list  
<img src="/screenshots/IMG_6064.png" width="200">

QR code scanned  
<img src="/screenshots/IMG_6063.png" width="200">

QR code detail (after tapping on a table view cell)  
<img src="/screenshots/IMG_6065.png" width="200">

## TODO bigger features
- Templates for special QR actions like mailto: facetime: message, event,... so the user does not need to write the format but only the data (and also add enum to the QR model with this information so for example the QRCell or detail view can show data accordingly)
- Template options for design of qr image that can be saved as a photo (right now its just the qr code)
- Switching of the rootviewcontroller to show animated splashscreen
- preset or user created tags (school, work, activities, ...) and their filtering in qr code list
