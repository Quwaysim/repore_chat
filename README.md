# Repore Chat

A real-time chat application built with Flutter and Firebase, designed for Repore's communication needs between admins, support agents, and customers.

## Features

- **Real-time Messaging**: Instant message delivery with status tracking (waiting, sent, delivered, read, failed).
- **Role-Based**: Easy to differentiate between admins, agents, and customers messages in chats.
- **Group Chat**: Create group conversations.
- **Message Status**: Visual indicators for message states.
- **Authentication**: Secure email/password authentication with role detection.

## Stack

- **Frontend**: Flutter (https://flutter.dev)
- **State Management**: Riverpod (https://riverpod.dev)
- **Backend**: Firebase: (https://firebase.google.com)
  - Firebase Authentication: for secure authentication (sign up and log in users with email and password) and auto detection of user roles. Email addresses with "admin" creates an admin account, "agent" creates an agent account, and all other emails create a customer account **(Not ideal, just for demo sake)**.
  - Realtime Database: for storing and updating chat messages in real-time, also svaing group metadata and message status tracking.
  - Cloud Firestore: for saving user profiles.

## Project Structure

```
assets/svgs/
lib/
├── auth/
│   ├── application/    # Auth state management (provider/notifier)
│   ├── domain/         # User models
│   └── presentation/   # Login/Signup screens
├── chat/
│   ├── application/    # Chat & presence management (provider/notifier)
│   ├── domain/         # Message & group models
│   └── presentation/   # Chat UI components
├── home/
│   └── presentation/   # Home screen & navigation
└── utils/
    ├── widgets/        # Reusable widgets
    └── helpers.dart    # Utility functions
```

## Getting Started

### Prerequisites

- Flutter SDK
- Firebase project
- IDE (VS Code or Android Studio)

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/quwaysim/repore_chat.git
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Configure Firebase:
   - Create a new Firebase project
   - Add your `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
   - Enable Authentication and Realtime Database

4. Run the app:
   ```bash
   flutter run
   ```

## User Roles

- **Admin**
- **Agent**
- **Customer**

## Message Status

- **Waiting**: message still being sent to realtime database; initial status.
- **Sent**: message successfully written to realtime database.
- **Delivered**: an authenticated user has opened the app and the message has been received by the user.
- **Read**: an authenticated user has opened a specific group, means they have read the group messages.
- **Failed**: message failed to be written to firebase.

## Key Components

### Authentication

- Email/password authentication.
- Automatic role assignment based on keywords inemail address (Approach used for demo sake).
- Persistent login state (handled by Firebase Auth).

### Messaging

- Real-time message delivery.
- Message status tracking through presence detection.
- Group chat support.

### UI/UX

- Clean, intuitive interface
- Role-specific views in chats.
- Message status indicators.

## State Management

The app uses Riverpod for state management with the following key providers:

- `authProvider`: Manages authentication state.
- `chatProvider`: Handles message operations.
- `presenceProvider`: Tracks user online status (and thus updating message status).
- `chatGroupProvider`: Manages group operations.

## Considerations

- Use of Firebase Realtime Database for chats.
- Use of Cloud Firestore for user profiles.
- Separation of features (project structure - clean arch, DRY).
- Separation of groups and messages nodes on Realtime Database, thus preventing the group nodes from growing too large and unnecessary fetching of messages when trying to read just group metradata.
- Use of svg assets for icons.
- Proper resource cleanup

## Security

- Firebase Authentication
- Secure message delivery
- Protected database and firestore rules.

## Future Improvements

- Forgot password feature.
- Validate email address/or use user ids on group creation.
- Add group management. Right now, groups can't be deleted, users can't be removed from a group.
- Add DMs.
- Add user profile management.
- Add group profile management.
- Update/redefine user roles assignment.
- Add push notifications for new messages.
