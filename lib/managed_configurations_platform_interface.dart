import 'package:managed_configurations/managed_configurations.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'managed_configurations_method_channel.dart';

abstract class ManagedConfigurationsPlatform extends PlatformInterface {
  /// Constructs a ManagedConfigurationsPlatform.
  ManagedConfigurationsPlatform() : super(token: _token);

  static final Object _token = Object();

  static ManagedConfigurationsPlatform _instance =
      MethodChannelManagedConfigurations();

  /// The default instance of [ManagedConfigurationsPlatform] to use.
  ///
  /// Defaults to [MethodChannelManagedConfigurations].
  static ManagedConfigurationsPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [ManagedConfigurationsPlatform] when
  /// they register themselves.
  static set instance(ManagedConfigurationsPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  static Stream<Map<String, dynamic>?> get mangedConfigurationsStream {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  static Future<Map<String, dynamic>?> get getManagedConfigurations async {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  /// This method is only supported on Android Platform
  static Future<void> reportKeyedAppStates(
    String key,
    Severity severity,
    String? message,
    String? data,
  ) async {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  static void dispose() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
