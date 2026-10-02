# 💊 Remindy

Remindy is a smart medication reminder and tracker built to help users manage their long-term medical needs. It features offline auto-save capabilities, smart duration tracking, and asynchronous **WhatsApp Notifications** to ensure you or your loved ones never miss a dose.

**Built for Shipathon 2026 🚢**

---

## ✨ Key Features

- **Smart Tracking**: Automatically calculates the remaining days of your longest medication ("Longest Meds" countdown) based on the start date.
- **Auto-Decrement Stock**: Medication stock automatically decreases based on your daily intake schedule.
- **Offline Auto-Save**: Your data is always safe. Remindy uses local storage (`shared_preferences`) to save your data instantly without needing an internet connection.
- **WhatsApp Notifications**: Sends real-time WhatsApp messages when a medication is marked as "Done" or "Missed", supporting international phone numbers.
- **Seamless Onboarding**: Remembers if you've completed the setup, skipping the onboarding/login process on subsequent app launches.

---

## 🛠 Tech Stack

- **Frontend**: Flutter (Dart)
- **State Management**: Native `ValueListenableBuilder` (No third-party packages)
- **Local Storage**: `shared_preferences`
- **Backend / Bot**: Node.js, `whatsapp-web.js` / Baileys (Custom GoWa Server)

---

## 🚀 How to Run & Test Locally (For Judges)

This application uses a custom Node.js server to handle WhatsApp notifications. To test the complete flow (including WhatsApp messages), please follow these steps carefully:

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) installed.
- [Node.js](https://nodejs.org/) installed.
- A smartphone with an active WhatsApp account (to act as the bot sender).

### Step 1: Clone the Repository

```bash
git clone [https://github.com/queenshafarania/remindy_app.git](https://github.com/queenshafarania/remindy_app.git)
cd remindy_app

```

### Step 2: Setup the WhatsApp Bot Server (GoWa)

1. Open your terminal and navigate to the server directory:

```bash
cd gowa_server

```

2. Install the required Node.js dependencies:

```bash
npm install

```

3. Start the server:

```bash
node index.js

```

4. A QR Code will be generated in your terminal. Open WhatsApp on your phone, navigate to **Linked Devices**, and scan the QR code.
5. Once it says "Ready" or "Connected" in the terminal, **leave this terminal open and running** in the background.

### Step 3: Configure the Flutter App IP Address

Since the WhatsApp server is running locally on your machine, you need to point the Flutter app to your computer's local IPv4 address.

1. Open your terminal and find your machine's local IP address (e.g., `192.168.x.x`).
2. Open the Flutter project in your code editor.
3. Navigate to `lib/services/whatsapp_service.dart`.
4. Locate the `baseUrl` variable and replace `127.0.0.1` with your computer's actual local IP address:

```dart
// Change this:
static const String baseUrl = '[http://127.0.0.1:3000/send/text](http://127.0.0.1:3000/send/text)';

// To something like this (keep the port :3000 or whatever port you use):
static const String baseUrl = '[http://192.168.1.5:3000/send/text](http://192.168.1.5:3000/send/text)';

```

_(Note: Do not use `localhost` or `127.0.0.1` if you are testing on a physical Android/iOS device via a cable)._

_(If you are testing the Flutter app on a physical Android or iOS device, both your test phone and your computer must be connected to the exact same Wi-Fi network. Additionally, you must use your machine's local IP address (like 192.168.1.x), because localhost or 127.0.0.1 will not work on a physical device.)_

### Step 4: Run the App

1. Open a **new terminal tab** (leave the server running in the first tab).
2. Ensure you are in the root `remindy_app` directory.
3. Install Flutter dependencies:

```bash
flutter pub get

```

4. Run the app on your preferred emulator or physical device:

```bash
flutter run

```

---

## 💡 Usage Guide for Judging

1. Open the app and complete the initial onboarding (enter a name and family phone number with country code, e.g., `+62812...` or `+1415...`).
2. Add a new medicine via the manual input form (or use the provided dummy data).
3. Go to the **Track** screen.
4. Tap the **Consume** (Done) or **Miss** button for a scheduled medicine.
5. Watch your WhatsApp receive an automated notification from the bot!

---

## 👨‍‍💻 Author

**Queenshafa Rania**

**Asiyah**

Vocational High School Student (Software Engineering)

_Created for Shipathon 2026_
