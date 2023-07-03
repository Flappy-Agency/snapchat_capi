import 'dart:io';

import 'package:flutter/material.dart';
import 'package:snapchat_capi/event_type.dart';
import 'package:snapchat_capi/snapchat_capi.dart';

void main() {
  SnapchatCAPI.initialize(
    apiKey:
        'eyJhbGciOiJIUzI1NiIsImtpZCI6IkNhbnZhc1MyU0hNQUNQcm9kIiwidHlwIjoiSldUIn0.eyJhdWQiOiJjYW52YXMtY2FudmFzYXBpIiwiaXNzIjoiY2FudmFzLXMyc3Rva2VuIiwibmJmIjoxNjg4MzczNDEzLCJzdWIiOiJiYmRiM2M3OC1mODYxLTQ1ODUtYTk1Yy1jN2QzMWQ4MTk2MDh-UFJPRFVDVElPTn5jOTZiYTk0Yy1jOTA1LTRhMjEtODkyYi1hNWEwMTcyZDc4ZjgifQ.RRRxyQGSWvYvZEBvlwO1uJ9GaNb3qFw7mkk9szloC6U',
    appId: Platform.isIOS ? 'ai.teasy.client' : 'com.melba.app',
    snapAppId: 'ec17b5f2-e117-4ffc-a894-f9f4fce47f32',
    advertisingId: '4b888239-74a9-483e-b62e-74813e354699',
    testMode: true,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void _incrementCounter() {
    try {
      SnapchatCAPI.instance.sendEvent(
        eventType: EventType.purchase,
        emailAddress: 'thomas@flappy.tech',
        phoneNumber: '+33642065625',
        price: '10.00',
        currency: 'EUR',
      );
    } catch (error) {
      print('Error in example app: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text('Coucou'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
