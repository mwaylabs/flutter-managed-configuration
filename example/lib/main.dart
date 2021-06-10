import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:managed_configurations/managed_configurations.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _managedAppConfigurations = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String managedAppConfigurations;
    try {
      managedAppConfigurations = json.encode(
          await ManagedConfigurations.getManagedConfigurations ??
              'no managed app configurations');
    } on PlatformException {
      managedAppConfigurations = 'Failed to get managed app configurations.';
    }
    if (!mounted) return;

    setState(() {
      _managedAppConfigurations = managedAppConfigurations;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Managed App Config'),
        ),
        body: Center(
          child: Column(
            children: [
              Text('Managed app config: $_managedAppConfigurations\n'),
              StreamBuilder<Map<String, dynamic>?>(
                stream: ManagedConfigurations.mangedConfigurationsStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text(json.encode(snapshot.data));
                  } else {
                    return Text("No changes at the moment");
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
