# Repore Chat

A real-time chat application built with Flutter and Firebase, designed for Repore's communication needs between admins, support agents, and customers.

# Overview
<img width="827" alt="Overview of the structure" src="https://github.com/user-attachments/assets/5b38c3a3-5f2f-4ca6-8631-5f1375ff8a04" />

# Technical Breakdown

### Real-time communication using Firebase.

- Use of Firebase's Realtime Database for messaging.
- Messages are stored in a hierarchical structure: messages/groupId/messageId, separated from their group nodes. This makes it easier to fetch groups metadata wihout having to fetch all messages in the group.
- Each message contains metadata like sender, senderRole, timestamp, and status and are updated in real-time, which makes it easier to update message UI. 
- Use of Firebase's .onValue listeners to get instant updates

### Differentiating message displays based on user roles.

- Role Assignment:
For the sake of this demo project, user roles (Admin, Agent and Customer) are determined by email during signup. If the email contains "admin", the user is assigned the admin role. If the email contains "agent", the user is assigned the agent role. Otherwise, the user is assigned the customer role. This is stored in Firestore user profile and in the messages in RTDB. 

When the chat bubble renders, the senderRole gotten from the message metadata is used to determine which color to use for the chat bubble. Side: chat bubbles are aligned to the right for messages sent by the current user and to the left for messages sent by other users.

### Implementing and updating message states.

We have 5 states; Waiting, Sent, Delivered, Read and Resend (failed). The initial status of messages is **Waiting**, and this is when the message is getting sent to the RTDB, usually takes ms. **Sent** is when the message is successfully written to the RTDB, **Delivered** is when the message has been received by the user. This is known by using a listener to detect when an authenticated user opens the app and has made it to the Homescreen, thus updating the status field for all messages in all groups the current user belongs to.

**Read** is when the authenticated user has opened the a specific group. The listener goes ahead and marks the  messages that are "not read" in that group ONLY as **Read**. As for **Resend**, this happens when the call to push the message to the RTDB fails.

### Optimizing the client app for scalability and performance.

The app uses the modular form of development, as the project structure allows for easy reusability of code and separation of concerns, with each feauture housed in its own directory with its peersonal state managers, models, data providers and UI components. New features can be easily added and existing features can be easily refactored or modified, thus making the app more maintainable and scalable.

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
│   ├── application/    # Auth state management
│   ├── domain/         # User model
│   └── presentation/   # Login/Signup screens
├── chat/
│   ├── application/    # Chat state management
│   ├── domain/         # Message model
│   └── presentation/   # Chat screen
├── home/
│   ├── application/    # Home (Groups and presence) state management
│   ├── domain/         # Group model
│   └── presentation/   # Home screen, group creation screen
├── utils/
│    ├── widgets/        # Reusable widgets
│    ├── app_colors.dart # App colors
│    ├── asset_paths.dart  # Asset paths
│    ├── enums.dart      # Enums
│    └── helpers.dart    # Utility functions   
└── main.dart
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
