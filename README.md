# managed_configurations

Plugin to support managed app configuration provided by a Mobile device management (MDM)

Allows to read out Managed App Configuration.
Provides a method and a stream which calls on managed app configuration changes.

## Additional Information

https://developer.android.com/work/managed-configurations

### Test on Android:
It could be that you need to factory reset your android device before installing TestDPC for testing.
* https://github.com/googlesamples/android-testdpc
* https://developer.android.com/work/guide#testing


## How to use

To get managed app configuration call:
```dart
final managedAppConfig = await ManagedConfigurations.getManagedConfigurations;
```

To listen for managed app config changes subscribe to the stream:
```dart
ManagedConfigurations.mangedConfigurationsStream.listen((managedAppConfig){
    print(managedAppConfig);
});
```

### (Android) Report state with KeyedAppStatesReporter

For more info please checkout Android doc:
https://developer.android.com/reference/kotlin/androidx/enterprise/feedback/KeyedAppStatesReporter

```dart
   ManagedConfigurations.reportKeyedAppStates("key", Severity.SEVERITY_INFO, "message", "data");
```




