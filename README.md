# QR Station app
This app will allow to scan for QR codes and will save them in a list.

<img src="/screenshots/icon.png" width="100">  

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
* App has English and 日本語 localization  

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

| Main Screen   | Scanned/created QR code list | Filtered QR code list  |
| ----------- | ----------- | ----------- |
| <img src="/screenshots/IMG_6061.png" width="200">  | <img src="/screenshots/IMG_6078.png" width="200"> | <img src="/screenshots/IMG_6064.png" width="200"> |  

| QR code scanned | QR code detail (after tapping on a table view cell)  |
| ------- | ------ |
|<img src="/screenshots/IMG_6063.png" width="200"> | <img src="/screenshots/IMG_6065.png" width="200"> |
