
# Location Explorer 

This is a documentation for location explorer, this is a mobile application build using flutter framework and backed with firebase as a backend for the project.

## Packages Used

Here is the list of packages used for the project.

```yaml
dependencies:
  flutter:
    sdk: flutter

  cupertino_icons: ^1.0.2
  firebase_core: ^2.24.2 
  email_validator: ^2.1.17
  firebase_auth: ^4.16.0
  shared_preferences: ^2.2.2
  camera: ^0.10.5+9
  firebase_storage: ^11.6.0
  cloud_firestore: ^4.14.0
  geolocator: ^10.1.0
  permission_handler: ^11.0.1
  geocoding: ^2.1.1
  provider: ^6.1.1
  url_launcher: ^6.2.4
  flutter_slidable: ^3.0.1
 ```



***Note please create your own firebae_options.dart as it is not added in this repository for privacy reason***

## Steps to build and run the app 

First make sure your machine is equip with dart programming language and flutter framework as the project is build using this.

### 1. Clone the repository 
By entering following command in the terminal of your directory
```bash
git clone https://github.com/KaustubhVaidya404/LocationExplorer.git
```

### 2. Navigate to the directory by 
```bash
ls 
```
```bash
cd [project directory]
```

### 3. Now install all the dependencies 
For installing all the dependencies run following command in the terminal
```bash
flutter pub add
```
This will install all the dependencies required for the project

### 4. Run the App 
for running the project first initilize the emulator or connect your mobile device with your device (wired/wireless).  \
**Note if you are using your mobile device make sure it has debug mode on** \
Now run following command in the terminal
```bash
flutter run lib/main.dart
```

### Build apk
For building apk file of the project run following command in the terminal 
```bash
flutter build apk 
```
This will create two files one for release and one for debug in the **build/app/outputs/flutter-apk/** 
