# 🚀 Game - Brain Training & Puzzle Collection

## 📝 Project Overview
**Game** is an iOS application designed to challenge and improve cognitive skills through a variety of mini-games. From color recognition to mathematical puzzles, the app offers a diverse set of challenges to keep the mind sharp.

## ✨ Features

### 🎮 Mini-Games Collection
The app features a wide range of interactive games, including:
*   **🎨 Color Challenges**: Test your reflexes and color perception with *Choose Random Color*, *Choose Right Color*, and *Color Intensity*.
*   **➗ Math Puzzles**: Sharpen your arithmetic skills with *Math Dual* and *Math Equation*.
*   **🧠 Memory & Logic**: Specific games like *Remember Spelling*, *Find the Card*, *Find Operator*, and *Odd Man Out*.
*   **⚡ Speed & Precision**: *Tap on the Number* and *Guess Week Day*.

### 🔗 Key Integrations
*   **📢 Google AdMob**: Integrated for monetization with banner and interstitial ads.
*   **⏳ ProgressHUD**: Provides user feedback during loading states.
*   **💀 SkeletonView**: Enhances the loading experience with shimmer effects.

## 🏗️ Code Structure & Architecture

The project follows the classic **Model-View-Controller (MVC)** design pattern, ensuring a clear separation of concerns.

### 📂 Directory Breakdown
The codebase is organized into the following key directories:

-   **`Game/Games`**: Contains the View Controllers for each mini-game. Each file (e.g., `MathDualVC.swift`, `FindTheCardVC.swift`) encapsulates the logic for a specific game mode.
-   **`Game/Helper`**: Utility classes and managers that support the application.
    -   `AdMob.swift`: Centralized class for managing Google Mobile Ads.
    -   `DEFAULTS.swift`: Detailed wrapper for `UserDefaults` to persist game settings and scores.
    -   `Singleton.swift`: Manages shared instances and global state.
    -   `Utils.swift`: General purpose utility functions.
-   **`Game/StoryBoard`**: Contains the UI layout files (`.storyboard`) defining the visual interface.
-   **`Game/Delegate`**: Holds the `AppDelegate` and `SceneDelegate` for application lifecycle management.

### ⚙️ Key Components
-   **`AdMob.swift`**: Handles the initialization and presentation of ads, abstracting the AdMob SDK implementation details from the View Controllers.
-   **`DEFAULTS.swift`**: A robust data persistence layer using `UserDefaults`, allowing valid data storage for high scores and user preferences.

## 📦 Dependencies

The project uses [CocoaPods](https://cocoapods.org) to manage dependencies. The key libraries include:

*   `Google-Mobile-Ads-SDK`: For displaying advertisements.
*   `ProgressHUD`: A lightweight HUD for showing loading progress.
*   `SkeletonView`: For creating loading placeholder animations.

## 🛠️ Setup Instructions

1.  **Clone the repository**:
    ```bash
    git clone <repository-url>
    ```
2.  **Install Dependencies**:
    Navigate to the project directory and run:
    ```bash
    pod install
    ```
3.  **Open the Workspace**:
    Always open the `.xcworkspace` file, not the `.xcodeproj` file:
    ```bash
    open Game.xcworkspace
    ```
4.  **Build and Run**:
    Select your target simulator or device in Xcode and press `Cmd + R` to run the app.

## 📱 Requirements
*   Xcode 13.0+
*   iOS 12.0+
*   CocoaPods
