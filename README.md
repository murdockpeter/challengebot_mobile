# ChallengeBot Mobile

A Flutter-based mobile application for viewing and managing game challenges. This app connects to a Firebase backend to display a real-time list of challenges between players.

## About This Project

This project serves as the mobile client for the ChallengeBot system. It's built with Flutter, allowing for a cross-platform experience on both Android and iOS from a single codebase. It currently displays a list of ongoing, completed, and cancelled challenges.

## Getting Started

To get a local copy up and running, follow these simple steps.

### Prerequisites

-   Flutter SDK: [https://flutter.dev/docs/get-started/install](https://flutter.dev/docs/get-started/install)
-   A configured IDE like VS Code or Android Studio.
-   Access to the Firebase project or your own Firebase project set up.

### Installation

1.  **Clone the repo**
    ```sh
    git clone https://github.com/murdockpeter/challengebot_mobile.git
    ```
2.  **Navigate to the project directory**
    ```sh
    cd challengebot_mobile
    ```
3.  **Install dependencies**
    ```sh
    flutter pub get
    ```
4.  **Set up Firebase**
    You will need to configure Firebase for your local build. Ensure you have the appropriate `google-services.json` (for Android) and `firebase_options.dart` files for your project. You can generate these from your Firebase project console.
    *Note: These files are included in the `.gitignore` for security and are not committed to the repository.*

5.  **Run the app**
    ```sh
    flutter run
    ```

## Project Structure

The project follows a standard Flutter structure, with the core application logic located in the `lib` directory.

-   `lib/models/`: Contains the data models that represent the Firestore documents (e.g., `challenge_model.dart`).
-   `lib/screens/`: Contains the UI widgets for each screen of the application (e.g., `challenge_list_screen.dart`).
-   `pubspec.yaml`: Defines the project's dependencies, including `cloud_firestore`.

## Backend

This application is powered by Google Cloud Firestore for its real-time database capabilities. The data is structured in a `challenges` collection, with each document representing a single challenge. The `Challenge` model in `lib/models/challenge_model.dart` directly maps to the structure of these documents.