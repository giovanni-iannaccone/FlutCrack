![logo-black-resized](https://github.com/user-attachments/assets/6a6c9558-8fa6-41ff-a49c-3be695e92208)

<a href="https://github.com/giovanni-iannaccone/FlutCrack"> This </a> is the official repository of the FlutCrack app.
# 👋 FlutCrack

FlutCrack is a Flutter application designed to crack hashes by comparing them against a dictionary of words.

## 📚 Features

- Hash cracking using a predefined wordlist
- Hash identifying  
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
2. Before cracking your hash, go to the Dictionary section and insert your wordlist. This step is required only on the first run, as the previous wordlist will be saved for future use.
3. Enter the hash you want to crack in the text field.
4. Select the hash algorithm from the dropdown menu.
5. Press the action button to start the cracking process.
6. The result will be displayed below the input fields.

## 🎬 Coming Soon
- [x] Hash identifying  
- [x] Cleaner code
- [ ] Salted hash ( maybe )
- [x] New UI

## 🧩 Contributing
We welcome contributions! Please follow these steps:

1. Fork the repository.
2. Create a new branch for your feature or bugfix.
3. Make your changes and commit them with descriptive messages.
4. Push your changes to your fork.
5. Create a pull request to the main repository.

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
  <img src="https://github.com/user-attachments/assets/d9e0c628-c761-48d9-8008-52472696a840" style="height: 500px;"/>
  <img src="https://github.com/user-attachments/assets/b19c67c6-fcb8-4ea0-b8cf-d2bdfad7212a" style="height: 500px;"/>
  <img src="https://github.com/user-attachments/assets/9c656139-6a35-481e-a6eb-1e821f25fe15" style="height: 500px;"/>
</div>


🚀 Happy Hacking ... 
