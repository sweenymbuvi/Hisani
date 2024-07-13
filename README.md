# Hisani: A Mobile App Streamlining Volunteer Center Discovery and Tailoring Donations for Charity Organisations

## Description
Hisani is a Flutter-based mobile app that simplifies the process of finding charity organizations and discovering their donation needs. Users can donate money or physical items and explore various volunteer opportunities. The app aims to foster community involvement and support for charitable causes.

## Project Setup/Installation Instructions
Before setting up the project, ensure you have the following installed:
- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- [Dart](https://dart.dev/get-dart)
- [Firebase](https://firebase.google.com/) account and project setup for authentication, database, and storage.
- [Android Studio](https://developer.android.com/studio) or [VS Code](https://code.visualstudio.com/) with the Flutter extension.
- Packages listed in pubspec.yaml:
  - firebase_core
  - firebase_auth
  - cloud_firestore
  - firebase_storage
  - google_maps_flutter
  - image_picker

  ## Installation Steps
  
- Clone the repo

    bash
    git clone https://github.com/sweenymbuvi/Hisani.git
    
- Install Dependencies

    bash
    flutter pub get
    
- Set up Firebase

1. Go to the [Firebase Console](https://console.firebase.google.com/).
   - Create a new project or select an existing one.
   - Follow the [Firebase setup documentation](https://firebase.flutter.dev/docs/overview) for Flutter to add your app to Firebase.
2. Download configuration files
   - Download google-services.json for Android and place it in the android/app directory.
3. Configure Firebase Authentication and Firestore
   - Enable Firebase Authentication in the Firebase Console and set up the required sign-in methods (e.g., Email/Password, Google).
   - Set up Firestore in the Firebase Console and create the necessary collections such as Users, organizations and Volunteering.

- Run the app 

    bash
    flutter run
    
## Usage Instructions

### How to Run

1. Ensure your development environment is properly set up and all dependencies are installed.
2. Use the following command to start the application on your connected device or emulator:
   ```bash
   flutter run
3. Alternatively, use your IDE’s tools to run the app.

### Examples

#### Finding Organizations:
1. Navigate to the search screen.
2. Use the search bar or category filters to find charity organizations.

#### Donating:
1. Go to the donations section.
2. Select a charity organization.
3. Choose to donate money or physical items.

#### Applying for Volunteer Opportunities:
1. Browse through the volunteer opportunities.
2. Select one.
3. Follow the instructions to apply.

#### Updating Profile:
1. Access the profile screen.
2. Update your details.
3. Upload a profile picture.
### Input/Output

#### Input:
- User interactions such as:
  - Searching
  - Uploading images
  - Filling out donation forms
  - Updating profiles

#### Output:
- Search results
- Profile updates
- Detailed views of organizations
- Donation confirmation

## Project Structure

### Overview

The project is organized as follows:

- lib/
  ├── screens/                  # Individual screen widgets like HomeScreen.dart, SearchScreen.dart, ProfileScreen.dart
  │   ├── HomeScreen.dart       # Screen widget for the home screen
  │   ├── SearchScreen.dart     # Screen widget for searching organizations
  │   ├── ProfileScreen.dart    # Screen widget for user profiles
  │   └── ...                   # Other screen widgets
  ├── models/                   # Data models, including OrganizationModel.dart and VolunteeringModel.dart
  │   ├── OrganizationModel.dart   # Data model for organization details
  │   ├── VolunteeringModel.dart   # Data model for volunteer opportunities
  │   └── ...                   # Other data models
  ├── services/                 # Backend services and API interactions, including Firebase and Google Maps integrations
  │   ├── FirebaseService.dart  # Service for Firebase integration
  │   ├── GoogleMapsService.dart# Service for Google Maps integration
  │   └── ...                   # Other backend services
  ├── utils/                    # Utility functions and helpers
  │   ├── constants.dart        # File containing constants used throughout the app
  │   ├── helpers.dart          # Helper functions for various tasks
  │   └── ...                   # Other utility files
  ├── assets/                   # Contains images, icons, and other static assets
  │   ├── images/               # Directory for images used in the app
  │   ├── icons/                # Directory for icons used in the app
  │   └── ...                   # Other asset directories
  ├── main.dart                 # The entry point of your Flutter application
  └── pubspec.yaml              # Lists the project’s dependencies and configuration


## Key Files

- *main.dart*: The entry point of the Flutter application.
- *screens/*:
  - Main screens like dashboard.dart, .dart, search_screen.dart, and volunteer_opportunities.dart.
- *models/*:
  - Data models that define the structure of various entities.
- *services/local_auth.dart*: Handles interactions with Firebase for authentication and data management.