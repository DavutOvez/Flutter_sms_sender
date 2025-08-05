import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:another_telephony/telephony.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final telephony = Telephony.instance;
  runApp(MyApp(telephony: telephony));
}

class MyApp extends StatelessWidget {
  final Telephony telephony;
  MyApp({required this.telephony});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: SmsPage(telephony: telephony));
  }
}

class SmsPage extends StatefulWidget {
  final Telephony telephony;
  SmsPage({required this.telephony});

  @override
  _SmsPageState createState() => _SmsPageState();
}

class _SmsPageState extends State<SmsPage> {
  late WebSocketChannel channel;

  @override
  void initState() {
    super.initState();
    _connectWebSocket();
  }

  void _connectWebSocket() async {
    bool? granted = await widget.telephony.requestSmsPermissions;
    if (granted != true) {
      print("❌ SMS permission denied");
      return;
    }

    const serverUrl = 'ws://<YOUR-SERVER-IP>:<PORT>>/ws/send-sms'; // ⚠️ Change this IP to your server
    try {
      channel = IOWebSocketChannel.connect(Uri.parse(serverUrl));
      print("✅ Connected to WebSocket");

      channel.stream.listen(
        (event) async {
          print("📥 Received data: $event");
          try {
            final data = jsonDecode(event);
            final phone = data['phone_number'];
            final msg = data['message'];
            await widget.telephony.sendSms(to: phone, message: msg);
            print("✅ SMS sent to: $phone");
          } catch (e) {
            print("❌ Invalid data or SMS error: $e");
          }
        },
        onError: (e) => print("❌ WebSocket error: $e"),
        onDone: () => print("🔌 WebSocket connection closed"),
      );
    } catch (e) {
      print("❌ Failed to connect: $e");
    }
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("SMS Listener")),
      body: Center(
        child: Text("Messages from the server will be sent as SMS."),
      ),
    );
  }
}