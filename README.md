# Challenge Tracker App

A Flutter application built to display and track game challenges from a Firebase Firestore database.

## 🚀 Features

- **Real-time Updates**: Connects to a Firestore collection named `challenges` and displays a live-updating list.
- **Informative UI**: Each challenge is displayed in a `Card` showing:
  - The name of the game being played.
  - The matchup: `Challenger vs. Opponent`.
  - A colored `Chip` indicating the challenge status (e.g., pending, completed, cancelled).
- **Clean Architecture**: Uses a `StreamBuilder` for efficient, real-time data handling from Firebase.

## 🛠️ Getting Started

Follow these instructions to get a copy of the project up and running on your local machine for development and testing.

### Prerequisites

- Flutter SDK installed on your machine.
- A Google account to create a Firebase Project.
- An Android Emulator or a physical Android device.

### Installation and Setup

1.  **Clone the repository** to your local machine.
    ```sh
    git clone <your-repository-url>
    cd flutter_application_1
    ```

2.  **Install Flutter dependencies**:
    ```sh
    flutter pub get
    ```

3.  **Configure Firebase**:
    This project is configured to work with Firebase. You must provide your own Firebase configuration files.

    - Create a new project in the Firebase Console.
    - Add an **Android app** to your Firebase project.
    - Follow the setup instructions to download the `google-services.json` file.
    - Place the `google-services.json` file in the `android/app/` directory of this project.
    - **Important**: The `google-services.json` file is intentionally not included in version control for security.

4.  **Run the app**:
    Connect your device/emulator and run the following command from the project root:
    ```sh
    flutter run
    ```

## 🔥 Firestore Data Structure

The application expects a collection named `challenges` in your Firestore database. Each document within this collection should have a structure that includes the following fields, which are used to build the UI:

- `game` (String)
- `challenger_name` (String)
- `opponent_name` (String)
- `status` (String) - e.g., "pending", "accepted", "completed", "cancelled"