# 📡 Real-Time SMS Sender via WebSocket (Flutter + FastAPI)

This project enables sending real-time SMS messages from a FastAPI backend to an Android device using WebSocket and Flutter. The Android device receives the message and sends it via SMS using the `another_telephony` package.

> ⚠️ **This project is intended for educational and local network use.** Use with caution in production environments. Always consider privacy and SMS costs.

---

## ✨ Features

- 📱 Flutter client connects to a WebSocket server.
- 🔄 Receives JSON payload with phone number and message.
- 📤 Sends SMS using native Android APIs.
- 🌐 FastAPI backend sends messages to all connected devices in real-time.

---

## 📁 Project Structure
```bash
project/
│
├── main.dart     # Flutter mobile client
└── main.py       # FastAPI WebSocket server
```

---

## ⚙️ Requirements

### 🔧 Flutter Side

- **Flutter SDK** (>=3.0.0 recommended)
- An **Android device** (emulator won't work for sending real SMS)
- Permissions to send SMS
- Dependencies:
  - [`another_telephony`](https://pub.dev/packages/another_telephony)
  - [`web_socket_channel`](https://pub.dev/packages/web_socket_channel)

Install packages:

```bash
flutter pub add another_telephony
flutter pub add web_socket_channel
```

### 🐍 Backend (Python Side)
- Python 3.8+
-	Packages:
-	fastapi
-	uvicorn

```bash
pip install fastapi uvicorn
```

🚀 Getting Started

# 1. Clone the Repository
```bash
git clone https://github.com/your-username/sms-websocket-system.git
cd sms-websocket-system

```
# 2. Backend Setup (FastAPI)

Start the WebSocket server:
```bash
python main.py
```
You’ll see logs like:
##### ✅ New connection established
##### 📤 Sending JSON: ...

The WebSocket will run at:
##### ws://<your-local-ip>:8000/ws/send-sms

# 3. Mobile App Setup (Flutter)
### 1. Replace the IP in main.dart with your computer’s local IP address:

```bash
const serverUrl = 'ws://192.168.X.X:8000/ws/send-sms';
```
    
### 2.	Ensure the Android device is on the same Wi-Fi network as your computer.
### 3.	Grant SMS permissions to the app.
### 4.	Run the app:
```bash
flutter run
```
You should see:
```bash
✅ Connected to WebSocket
📥 Incoming data: ...
```
#### 🔐 Don’t forget to allow SMS permission manually if prompted on the device.

## 🧪 How to Send a Test SMS

#### Once the device is connected to the server, you can send a test message using the following HTTP request:
```bash
const serverUrl = 'ws://192.168.X.X:8000/ws/send-sms';
```
### This will send the following test message:
```bash
{
  "phone_number": "<phone_number>",
  "message": "This is a test message!"
}
```
### ⚠️ Warnings and Best Practices
-	✅ Works only on physical Android device
-	❌ Does not work on iOS or iOS simulators
-   🔒 This is an insecure implementation for testing. Add:
-   Authentication
-  	HTTPS (WSS)
-  	Rate limiting
-  	Logging
-  	📵 Respect user privacy and local SMS regulations.
# 👨‍💻 Author
##	Name: Davut Ovezov
##	GitHub: @DavutOvez
