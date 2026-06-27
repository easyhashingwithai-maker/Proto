# Proto Installation Guidelines

This document provides detailed instructions on how to set up, develop, and deploy the Proto AI Assistant on various platforms.

## 1. VS Code Setup
To get the best development experience with Proto in VS Code:

1.  **Install Flutter Extension**: Search for "Flutter" in the VS Code Extensions view (Ctrl+Shift+X) and install it. This will also install the Dart extension.
2.  **Open Project**: Open the root folder of the Proto project in VS Code.
3.  **Get Dependencies**: VS Code should automatically prompt you to run `flutter pub get`. If not, open the terminal in VS Code and run it manually.
4.  **Select Device**: Click on the status bar at the bottom right to select a target device (e.g., Android Emulator, iOS Simulator, or Chrome/Desktop).
5.  **Run & Debug**: Press `F5` or go to the "Run and Debug" view to start the application with a debugger attached.

## 2. Android Installation & APK Build

### Running on Android Device/Emulator
1.  Enable **Developer Options** and **USB Debugging** on your Android device.
2.  Connect the device to your machine via USB.
3.  Run `flutter run` in the terminal.

### Building the APK
To generate a distributable APK file:
1.  Open your terminal in the project root.
2.  Run the following command:
    ```bash
    flutter build apk --release
    ```
3.  Once finished, the APK will be located at:
    `build/app/outputs/flutter-apk/app-release.apk`
4.  Transfer this file to your Android phone and open it to install.

## 3. iOS Installation (macOS Required)

### Running on iOS Simulator
1.  Ensure you have **Xcode** installed.
2.  Open the Simulator via Xcode or run `open -a Simulator`.
3.  Run `flutter run` in the terminal.

### Building for iOS Device
1.  You must have an Apple Developer account.
2.  Open the `ios/Runner.xcworkspace` file in Xcode.
3.  Select your development team in the **Signing & Capabilities** tab.
4.  Run the following command:
    ```bash
    flutter build ios --release
    ```
5.  To install on a physical device, use Xcode to "Run" the app on your connected iPhone.

## 4. Publishing to GitHub
To share your version of Proto on GitHub:

1.  **Create a New Repository** on [GitHub](https://github.com/new). Do not initialize with a README.
2.  **Initialize Local Repo** (if not already done):
    ```bash
    git init
    git add .
    git commit -m "Initial Proto implementation"
    ```
3.  **Add Remote and Push**:
    ```bash
    git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO_NAME.git
    git branch -M main
    git push -u origin main
    ```

## 5. Deployment Checklist
- [ ] Ensure **Ollama** is installed and running on the host machine for AI features.
- [ ] Ensure `assets/models/robot_head.glb` exists.
- [ ] For cloud AI features, enter your API keys in the **Settings** screen within the app.
