# FeedMeTest

A Flutter-based application for managing food orders, from customer menu selection to kitchen preparation.

## 📝 Description

This project is a comprehensive food ordering system. It includes modules for browsing the menu, adding items to a cart, placing an order, and a kitchen interface to track and manage incoming orders. It also features a chatbot for user assistance.

## ✨ Features

- **Menu:** Browse available food items.
- **Cart:** Add and manage items before checkout.
- **Ordering:** Place orders seamlessly.
- **Kitchen View:** A dedicated interface for kitchen staff to view and manage incoming orders.
- **AI Bot:** An integrated chatbot to assist users.

## 🚀 Getting Started

This project is a starting point for a Flutter application.

### Prerequisites

- Flutter SDK version `3.32.2`
- [Dart SDK](https://dart.dev/get-dart)

### Installation & Running

1.  Clone the repository:
    ```sh
    git clone https://github.com/SuruchBoss/se-take-home-assignment.git
    cd feedmetest
    ```
2.  Install dependencies:
    ```sh
    flutter pub get
    ```
3.  Run the app:
    ```sh
    flutter run
    ```

### Building the APK

1.  To build the release APK, run the following command:
    ```sh
    flutter build apk --release
    ```
2.  The output file can be found at:
    ```
    build/app/outputs/flutter-apk/app-release.apk
    ```

## 🛠️ Technologies Used

- **Flutter:** For building the cross-platform mobile application.
- **Dart:** The programming language used for Flutter development.
- **BLoC:** For state management, ensuring a clean and scalable architecture.

## 📂 Project Structure

The project is structured following a feature-first approach, with each feature encapsulated in its own directory.

```
lib
├── features
│   ├── bot         # Chatbot feature
│   ├── cart        # Shopping Cart feature
│   ├── kitchen     # Kitchen order management
│   ├── menu        # Food menu
│   └── user        # User management
└── main.dart       # App entry point
```