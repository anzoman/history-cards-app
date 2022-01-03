# History Cards Application

<p align="center">
  <img src="https://seeklogo.com/images/F/flutter-logo-5086DD11C5-seeklogo.com.png" width="11%"/>
  <img src="https://upload.wikimedia.org/wikipedia/commons/7/7e/Dart-logo.png" width="14%"/>
</p>

This is a mobile app for learning history written in Flutter and Dart (+ Firebase).

| Mobile app video               | https://youtu.be/vRPqyU8SQYc              |
| ------------------------------ |:-----------------------------------------:|

## Prerequisites

To properly run the application from Android Studio (or Visual Studio code) you have to install the following:

- [Android Studio](https://developer.android.com/studio/install)
- [Flutter and Dart](https://flutter.dev/docs/get-started/install)
- Dart and Flutter plugins in Android Studio
- Install and configure your Android Emulator
- [Editor setup](https://flutter.dev/docs/get-started/editor)

If there are some problems with running the app you should check if every installation was done successfully.
You can do that by running `flutter doctor`. If the problem persists try running `flutter clean`. 
To generate an apk by yourself run `flutter build apk` and for ipa file `flutter build ios` (works only on Mac with Xcode).

Below you can see some application screenshots (taken on Pixel 3a API 28 emulator device and Pixel 3a XL API 29 - for testing dark mode):


<img src="https://github.com/anzoman/history-cards-app/blob/main/history_cards_app/assets/snapshots/Screenshot_1641199837.png?raw=true" width="23%"></img> 
<img src="https://github.com/anzoman/history-cards-app/blob/main/history_cards_app/assets/snapshots/Screenshot_1641199858.png?raw=true" width="23%"></img> 
<img src="https://github.com/anzoman/history-cards-app/blob/main/history_cards_app/assets/snapshots/Screenshot_1641199866.png?raw=true" width="23%"></img> 
<img src="https://github.com/anzoman/history-cards-app/blob/main/history_cards_app/assets/snapshots/Screenshot_1641199895.png?raw=true" width="23%"></img> 
<img src="https://github.com/anzoman/history-cards-app/blob/main/history_cards_app/assets/snapshots/Screenshot_1641199900.png?raw=true" width="23%"></img> 
<img src="https://github.com/anzoman/history-cards-app/blob/main/history_cards_app/assets/snapshots/Screenshot_1641199949.png?raw=true" width="23%"></img> 
<img src="https://github.com/anzoman/history-cards-app/blob/main/history_cards_app/assets/snapshots/Screenshot_1641199960.png?raw=true" width="23%"></img> 
<img src="https://github.com/anzoman/history-cards-app/blob/main/history_cards_app/assets/snapshots/Screenshot_1641200159.png?raw=true" width="23%"></img> 
<img src="https://github.com/anzoman/history-cards-app/blob/main/history_cards_app/assets/snapshots/Screenshot_1641200276.png?raw=true" width="23%"></img> 
<img src="https://github.com/anzoman/history-cards-app/blob/main/history_cards_app/assets/snapshots/Screenshot_1641200319.png?raw=true" width="23%"></img> 
<img src="https://github.com/anzoman/history-cards-app/blob/main/history_cards_app/assets/snapshots/Screenshot_1641200325.png?raw=true" width="23%"></img> 
<img src="https://github.com/anzoman/history-cards-app/blob/main/history_cards_app/assets/snapshots/Screenshot_1641200332.png?raw=true" width="23%"></img> 
<img src="https://github.com/anzoman/history-cards-app/blob/main/history_cards_app/assets/snapshots/Screenshot_1641200357.png?raw=true" width="23%"></img> 
<img src="https://github.com/anzoman/history-cards-app/blob/main/history_cards_app/assets/snapshots/Screenshot_1641200368.png?raw=true" width="23%"></img> 
<img src="https://github.com/anzoman/history-cards-app/blob/main/history_cards_app/assets/snapshots/Screenshot_1641200376.png?raw=true" width="23%"></img> 
<img src="https://github.com/anzoman/history-cards-app/blob/main/history_cards_app/assets/snapshots/Screenshot_1641200446.png?raw=true" width="23%"></img> 
<img src="https://github.com/anzoman/history-cards-app/blob/main/history_cards_app/assets/snapshots/Screenshot_1641200449.png?raw=true" width="23%"></img> 
<img src="https://github.com/anzoman/history-cards-app/blob/main/history_cards_app/assets/snapshots/Screenshot_1641200454.png?raw=true" width="23%"></img> 
<img src="https://github.com/anzoman/history-cards-app/blob/main/history_cards_app/assets/snapshots/Screenshot_1641200461.png?raw=true" width="23%"></img> 
<img src="https://github.com/anzoman/history-cards-app/blob/main/history_cards_app/assets/snapshots/Screenshot_1641200472.png?raw=true" width="23%"></img> 
<img src="https://github.com/anzoman/history-cards-app/blob/main/history_cards_app/assets/snapshots/Screenshot_1641200509.png?raw=true" width="23%"></img> 
<img src="https://github.com/anzoman/history-cards-app/blob/main/history_cards_app/assets/snapshots/Screenshot_1641200636.png?raw=true" width="23%"></img> 
<img src="https://github.com/anzoman/history-cards-app/blob/main/history_cards_app/assets/snapshots/Screenshot_1641203224.png?raw=true" width="23%"></img> 
<img src="https://github.com/anzoman/history-cards-app/blob/main/history_cards_app/assets/snapshots/Screenshot_1641203781.png?raw=true" width="23%"></img> 

The app has light mode in most activities, but on Android 10 (API 29) you can try to enable 
"Dark mode" display of apps and this will turn some views darker.

<img src="https://firebase.google.com/images/brand-guidelines/logo-built_black.png" width="30%"/>
