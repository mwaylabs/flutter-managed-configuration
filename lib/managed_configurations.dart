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
  Stream<Map<String, dynamic>?> get mangedConfigurationsStream {
    return ManagedConfigurationsPlatform.instance.mangedConfigurationsStream;
  }

  Future<Map<String, dynamic>?> get getManagedConfigurations async {
    return ManagedConfigurationsPlatform.instance.getManagedConfigurations;
  }

  /// This method is only supported on Android Platform
  Future<void> reportKeyedAppStates(
    String key,
    Severity severity,
    String? message,
    String? data,
  ) async {
    return ManagedConfigurationsPlatform.instance
        .reportKeyedAppStates(key, severity, message, data);
  }

  void dispose() {
    return ManagedConfigurationsPlatform.instance.dispose();
  }
}
