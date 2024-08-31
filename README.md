![logo-black-resized](https://github.com/user-attachments/assets/6a6c9558-8fa6-41ff-a49c-3be695e92208)

<a href="https://github.com/giovanni-iannaccone/FlutCrack"> This </a> is the official repository of the FlutCrack app. 
# 👋 FlutCrack

FlutCrack is a Flutter application designed to crack hashes by comparing them against a dictionary of words.

## 📚 Features

- Hash cracking and algorithms identifying
- Support for multiple hash algorithms:
  - MD5
  - SHA-1
  - SHA-224
  - SHA-256
  - SHA-384
  - SHA-512
  - SHA-512/224
  - SHA-512/256
- User-friendly interface with text input and dropdown selection for hash algorithms
- Dynamic wordlists support ( from web, device memory or in-app created )
- Words hasher

## 👩‍💻 Installation

### 📜 Prerequisites

- Flutter SDK: [Install Flutter](https://flutter.dev/docs/get-started/install)
- Dart: [Install Dart](https://dart.dev/get-dart)
- A compatible IDE like Android Studio, IntelliJ IDEA, or VS Code

### 🧪 Installation Steps

1. Clone the repository:
   ```
   git clone https://github.com/giovanni-iannaccone/FlutCrack
   cd FlutCrack
   ```
2. Get the dependencies:
   ```
   flutter pub get
   ```
3. Run the application:
   ```
   flutter run
   ```

### 🧬 Generating the APK
To generate an APK file for installation on an Android device, follow these steps:

1. Open a terminal and navigate to the project directory.
2. Run the following command to build the APK
```
flutter build apk --release
```
This command will generate an APK file at build/app/outputs/flutter-apk/app-release.apk.

### 📱 Installing the APK on Your Phone
#### 🎈 Easy way
Download the last release
#### 🧊 Cool way
Connect your Android device to your computer via USB.
Enable USB debugging on your Android device. You can find this option in Settings > Developer options. If Developer options is not visible, you may need to enable it by tapping Build number seven times in Settings > About phone.
Copy the generated APK file (app-release.apk) to your device.
On your device, locate the APK file using a file manager app and tap on it to install.
You may need to allow installations from unknown sources. This can be done by going to Settings > Security > Unknown sources.

( or any method you like to download an apk )

## 🎮 Usage

1. Open the FlutCrack application on your device or emulator.
2. Before cracking your hash, go to the wordlists section, create and add words to your wordlist. This step is required only on the first run, as the previous wordlist will be saved for future use.
3. Go back to the home screen, pick the wordlist you want to use from those you created, from your device memory or from the web.
4. Enter the hash you want to crack in the text field.
5. Select the hash algorithm from the dropdown menu (if you know it).
6. Press the action button to start the cracking process.
7. The result will be displayed below the input fields.

> [!CAUTION]
> The FlutCrack team does not assume any responsibility for the improper use of the app.

## 🎬 Coming Soon
- [x] Hash identifying  
- [x] Cleaner code
- [x] New UI
- [x] Multiple wordlists support
- [x] Web Wordlists installation

## 🧩 Contributing
We welcome contributions! Please follow these steps:

1. Fork the repository.
2. Create a new branch ( using <a href="https://medium.com/@abhay.pixolo/naming-conventions-for-git-branches-a-cheatsheet-8549feca2534">this</a> convention).
3. Make your changes and commit them with descriptive messages.
4. Push your changes to your fork.
5. Create a pull request to the main repository.

### 📂 Folder Structure 
```
.
├── core/                                Core components
│   └── utils/                           Common utils files 
├── features/                            Everything which isn't a common function
│   ├── about/                           About Us screen stuff
│   │   └── presentation/                The about us Screen
│   ├── hashing/                         Hashing screens stuff
│   │   ├── data/                        Data management for hashing 
│   │   ├── domain/                      Logic for hashing functions
│   │   │   ├── entities/                Algorithms and hashing functions
│   │   │   ├── repositories/            Implementations to access hashing data  
│   │   │   └── usecases/                Use cases for hashing 
│   │   └── presentation/                Hashing screens
│   │       ├── state/                   Hashing screens state notifier
│   │       └── widgets/                 Widget for hashing screens
│   └── wordlists/                       Wordlists screens stuff
│       ├── data/                        Data management for wordlists
│       ├── domain/                      Logic for wordlists related functions
│       │   ├── repositories/            Implementations to access wordlists data  
│       │   └── usecases/                Use cases for wordlists
│       └── presentation/                Wordlists screens
│           └── state/                   Wordlists screens state notifier
└── shared/data/                         classes to manage things
```
                 
### 🍃 Contributors
<a href="https://github.com/giovanni-iannaccone/FlutCrack/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=giovanni-iannaccone/FlutCrack"  alt="FLutCrack Contributors"/>
</a>

## 🔭 Learn
Flutter: https://docs.flutter.dev/cookbook </br>
Hash cracking: https://tryhackme.com/r/room/cryptographyintro

## ⚖ License
This project is licensed under the GPL-3.0 License. See the LICENSE file for details.

## ⚔ Contact
- For any inquiries or support, please contact <a href="mailto:iannacconegiovanni444@gmail.com"> iannacconegiovanni444@gmail.com </a>.
- Visit my site for more informations about me and my work <a href="https://giovanni-iannaccone.gith
ub.io" target=”_blank” rel="noopener noreferrer"> https://giovanni-iannaccone.github.io </a>

## 📸 Screenshots
<div style="display: grid;">
  <img src="https://github.com/user-attachments/assets/c08458e7-e23b-492c-be6b-9c6004bae73b" style="height: 500px;"/>
  <img src="https://github.com/user-attachments/assets/c880ae05-2698-46bb-a434-1163c0e79cc3" style="height: 500px;"/>
  <img src="https://github.com/user-attachments/assets/9f843bd6-9d15-4709-a9c9-4b0addcffc36" style="height: 500px;"/>
</div>
<br>

🚀 Happy Hacking ... 
