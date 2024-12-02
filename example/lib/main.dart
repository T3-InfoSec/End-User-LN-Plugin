import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:tlp_connection_plugin/tlp_connection_plugin.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TLP Conn Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'TLP Conn Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TlpConnectionPlugin _tlpConnectionPlugin = TlpConnectionPlugin();
  late FlutterLocalNotificationsPlugin _notificationsPlugin;

  @override
  void initState() {
    super.initState();
    // _initializeNotifications();
    // _listenForMessages();
  }

  /// Initialize flutter_local_notifications
  void _initializeNotifications() {
    _notificationsPlugin = FlutterLocalNotificationsPlugin();

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher'); // App icon
    const InitializationSettings initSettings = InitializationSettings(android: androidSettings);

    _notificationsPlugin.initialize(
      initSettings,
      onDidReceiveBackgroundNotificationResponse: (payload) async {
        // Handle notification tap
        debugPrint('Notification tapped with payload: $payload');
      },
    );
  }

  void _listenForMessages() {
    _tlpConnectionPlugin.receivedMessageStream.listen((message) {
      _showNotification(message.toString());
    });
  }

  Future<void> _showNotification(String message) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'new_message_channel', // Channel ID
      'New Message', // Channel name
      channelDescription: 'Displays notifications for new messages',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
    );
    const NotificationDetails platformDetails = NotificationDetails(android: androidDetails);

    await _notificationsPlugin.show(
      0, // Notification ID
      'TLP answer received', // Title
      message, // Body
      platformDetails,
      payload: message, // Custom payload (optional)
    );
  }

  int t = 3000;
  int stepValue = 3000;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 108),
            StreamBuilder<ConnectionStatus>(
                stream: _tlpConnectionPlugin.connectionStatusStream,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  final status = snapshot.data;
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("HELLO WORLD ${status?.name.toUpperCase()}"),
                    ],
                  );
                }),
            const SizedBox(height: 108),
            const Text("T:", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      // Safeguard against values below the minimum allowed (1000)
                      if (stepValue > 100) {
                        stepValue = stepValue ~/ 10; // Perform integer division
                        t = stepValue;
                      }
                    });
                  },
                  child: const Icon(Icons.remove),
                ),
                Text(
                  stepValue.toString(),
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      // Safeguard against exceeding a reasonable maximum value
                      const int maxAllowed = 10000000;
                      if (stepValue <= maxAllowed) {
                        // Prevent overflow
                        stepValue *= 10;
                        t = stepValue;
                      }
                    });
                  },
                  child: const Icon(Icons.add),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _tlpConnectionPlugin.start(
          context,
          'localhost:8080',
          ConnectionType.websocket,
          t,
          (status) {},
        ),
        tooltip: 'TLP TEST',
        child: const Icon(Icons.add),
      ),
    );
  }
}
