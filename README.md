# 👻 GhostMe Mobile

> "The line is secure. The void is listening."

**GhostMe Mobile** is a secure, ephemeral chat client built with Flutter. It serves as the mobile "séance" interface for the [GhostMe Web](https://github.com/BryceWayne/GhostMe-web) backend, allowing users to communicate with the void (and each other) via a secure, self-destructing WebSocket stream.

## 🔮 Features

* **Secure Uplink:** Connects to Google Cloud Run via authenticated WSS (Secure WebSockets).
* **Ephemeral Messaging:** Messages self-destruct (dissolve) from the UI after 10 seconds.
* **"Séance" Theme:** A custom dark UI featuring `VoidPurple`, `SeanceLavender`, and `LinkGreen` aesthetics.
* **Protocol Translation:** Automatically strips HTMX tags from the backend to display clean text on mobile.
* **Emoji Parsing:** Translates incantations like `:ghost:` into 👻.
* **Smart Connectivity:** Native `pingInterval` keep-alives and robust reconnection logic ("Link Severed" / "Link Established").
* **Firebase Identity:** Passes verified Firebase Auth ID tokens to the backend for hybrid authentication.

## 🛠 Tech Stack

* **Framework:** [Flutter](https://flutter.dev/) (Dart)
* **State Management:** [Flutter Bloc](https://pub.dev/packages/flutter_bloc) (Event-driven architecture)
* **Networking:** `web_socket_channel` (IOWebSocketChannel for header support)
* **Auth:** `firebase_auth`
* **Fonts:** Google Fonts (`Creepster`, `Courier Prime`, `Share Tech Mono`)

## ⚡️ Getting Started

### Prerequisites

1.  **Flutter SDK:** Ensure you have Flutter installed and configured (`flutter doctor`).
2.  **Firebase Project:** You need a `google-services.json` file placed in `android/app/` (and `GoogleService-Info.plist` for iOS).
3.  **Backend:** The app expects a running instance of [GhostMe Web](https://github.com/BryceWayne/GhostMe-web).

### Installation

1.  **Clone the repo:**
    ```bash
    git clone [https://github.com/BryceWayne/GhostMe-mobile.git](https://github.com/BryceWayne/GhostMe-mobile.git)
    cd ghost_me_mobile
    ```

2.  **Install dependencies:**
    ```bash
    flutter pub get
    ```

3.  **Configure Environment:**
    Update `lib/logic/blocs/chat/chat_bloc.dart` with your backend URL if different from default:
    ```dart
    final Uri _serverUrl = Uri.parse('wss://YOUR-CLOUD-RUN-URL/ws');
    ```

4.  **Incant (Run):**
    ```bash
    flutter run
    ```

## 📂 Architecture

The project follows a clean **Logic / Presentation** split:

```text
lib/
├── core/
│   └── theme/
│       └── ghost_theme.dart    # The "Séance" design system
├── logic/
│   └── blocs/
│       ├── auth/               # Firebase Authentication logic
│       └── chat/               # WebSocket & Message logic
│           ├── chat_bloc.dart  # The brain (Auth, HTMX parsing, Timers)
│           ├── chat_event.dart # Events (SendMessage, DissolveMessage)
│           └── chat_state.dart # State (GhostMessage model)
└── presentation/
    ├── screens/
    │   ├── login_screen.dart   # Entry point
    │   └── chat_screen.dart    # The main interface
    └── widgets/
        └── seance_header.dart  # Connection status visualizer

```

## 🔗 Backend

This mobile app requires the **GhostMe Web** backend to function.

* **Repo:** [github.com/BryceWayne/GhostMe-web](https://github.com/BryceWayne/GhostMe-web)
* **Tech:** Go (Golang), Google Cloud Run, Firestore/MemoryStore.

## 📜 License

This project is open source. Use it to summon code from the void responsibly.