import 'managed_configurations_platform_interface.dart';

enum Severity { SEVERITY_INFO, SEVERITY_ERROR }

extension SeverityExtensions on Severity {
  int toInteger() {
    switch (this) {
      case Severity.SEVERITY_INFO:
        return 1;
      case Severity.SEVERITY_ERROR:
        return 2;
    }
  }
}

class ManagedConfigurations {
  static Stream<Map<String, dynamic>?> get mangedConfigurationsStream {
    return ManagedConfigurationsPlatform.mangedConfigurationsStream;
  }

  static Future<Map<String, dynamic>?> get getManagedConfigurations async {
    return ManagedConfigurationsPlatform.getManagedConfigurations;
  }

  /// This method is only supported on Android Platform
  static Future<void> reportKeyedAppStates(
    String key,
    Severity severity,
    String? message,
    String? data,
  ) async {
    return ManagedConfigurationsPlatform.reportKeyedAppStates(
        key, severity, message, data);
  }

  static void dispose() {
    return ManagedConfigurationsPlatform.dispose();
  }
}
