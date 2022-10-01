// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:first_app/network/mqtt_client.dart';
import 'package:first_app/network/mqtt_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  final mqttClient = MqttClient.setup();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to the Flutter',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Mqtt broker connection poc'),
        ),
        body: Center(
          child:
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Observer(builder: (_){
                    return Text(mqttClient.message);
                  }),
                  ElevatedButton(onPressed: _onClick, child: const Text("Connect to broker"))
                ],
              ),
        ),
      ),
    );
  }

  void _onClick() async {
    await mqttClient.connect();
    mqttClient.subscribeToTopic(MqttConstants.topicName);
    mqttClient.publishToTopic(MqttConstants.topicName, "Surprise, i'm back!");
  }
}
