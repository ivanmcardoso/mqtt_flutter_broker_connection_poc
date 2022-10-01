import 'dart:io';

import 'package:first_app/network/mqtt_constants.dart';
import 'package:mobx/mobx.dart';
import 'package:mqtt_client/mqtt_client.dart' as mqtt;
import 'package:mqtt_client/mqtt_server_client.dart' as mqtt_server;
import 'dart:async';

class MqttClient {
  late mqtt_server.MqttServerClient _client;

  final _message = Observable("should change to publish message");
  String get message => _message.value;
  set message(String newValue) => _message.value = newValue;

  late Action updateMessage;

  MqttClient.setup() {
    updateMessage = Action(_updateMessage);

    _client = mqtt_server.MqttServerClient.withPort(MqttConstants.brokerUrl,
        MqttConstants.clientIdentifier, MqttConstants.port);
    _client.secure = true;
    _client.securityContext = SecurityContext.defaultContext;
    _client.logging(on: false);
    _client.keepAlivePeriod = 20;
  }

  Future<void> connect() async {
    await _connectToBroker();
    if (_client.connectionStatus != null) {
      _checkConnectionState(_client.connectionStatus!.state);
    }
  }

  void subscribeToTopic(String topicName) {
    print("mqtt subscribe on: $topicName");
    _client.subscribe(topicName, mqtt.MqttQos.exactlyOnce);
    _client.updates?.listen(_onMessageReceived);
  }

  void publishToTopic(String pubTopic, String messagePub) {
    final builder = mqtt.MqttClientPayloadBuilder();
    builder.addString(messagePub);
    _client.publishMessage(pubTopic, mqtt.MqttQos.atMostOnce, builder.payload!);
  }

  Future<void> _connectToBroker() async {
    try {
      await _client.connect(MqttConstants.suid, MqttConstants.pass);
    } /* on Exception */ catch (e) {
      print('mqtt Error:: _connectToBroker - $e');
      _client.disconnect();
    }
  }

  void _checkConnectionState(mqtt.MqttConnectionState state) {
    if (state == mqtt.MqttConnectionState.connected) {
      print('mqtt Status:: client connected');
    } else {
      print('mqtt Error:: _checkConnectionState: $state');
      _client.disconnect();
    }
  }

  void _onMessageReceived(List<mqtt.MqttReceivedMessage<mqtt.MqttMessage>> c) {
    final mqtt.MqttPublishMessage recMess =
        c[0].payload as mqtt.MqttPublishMessage;
    final String message =
        mqtt.MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
    updateMessage([message]);
    print("mqtt Subscribe::GOT A NEW MESSAGE $message");
  }

  void _updateMessage(String value) {
    message = value;
  }
}
