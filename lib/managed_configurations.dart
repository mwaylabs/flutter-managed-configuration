import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';

const String getManagedConfiguration = "getManagedConfigurations";

class ManagedConfigurations {
  static const MethodChannel _managedConfigurationMethodChannel =
      const MethodChannel('managed_configurations_method');
  static const EventChannel _managedConfigurationEventChannel =
      const EventChannel('managed_configurations_event');

  static StreamController<Map<String, dynamic>?>
      _mangedConfigurationsController =
      StreamController<Map<String, dynamic>?>.broadcast();

  static Stream<Map<String, dynamic>?> _managedConfigurationsStream =
      _mangedConfigurationsController.stream.asBroadcastStream();

  /// Returns a broadcasst stream which calls on managed app configuration changes
  /// Json will be returned
  /// Call [dispose] when stream is not more necassary
  static Stream<Map<String, dynamic>?> get mangedConfigurationsStream {
    if (_actionApplicationRestrictionsChangedubscription == null) {
      _actionApplicationRestrictionsChangedubscription =
          _managedConfigurationEventChannel
              .receiveBroadcastStream()
              .listen((newManagedConfigurations) {
        if (newManagedConfigurations != null) {
          _mangedConfigurationsController
              .add(json.decode(newManagedConfigurations));
        }
      });
    }
    return _managedConfigurationsStream;
  }

  static StreamSubscription<dynamic>?
      _actionApplicationRestrictionsChangedubscription;

  /// Returns managed app configurations as Json
  static Future<Map<String, dynamic>?> get getManagedConfigurations async {
    final String? version = await _managedConfigurationMethodChannel
        .invokeMethod(getManagedConfiguration);
    if (version != null) {
      return json.decode(version);
    } else {
      return null;
    }
  }

  static dispose() {
    _actionApplicationRestrictionsChangedubscription?.cancel();
  }
}
