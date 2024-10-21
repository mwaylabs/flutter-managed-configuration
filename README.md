# managed_configurations

Plugin to support managed app configuration provided by a Mobile device management (MDM)

Allows to read out Managed App Configuration.
Provides a method and a stream which calls on managed app configuration changes.

## Additional Information

### Android:

https://developer.android.com/work/managed-configurations

#### How to Test
It could be that you need to factory reset your android device before installing TestDPC for testing.
* https://github.com/googlesamples/android-testdpc
* https://developer.android.com/work/guide#testing

### iOS/macOS
https://developer.apple.com/documentation/foundation/nsuserdefaults#2926901

#### How to Test

Apple does not provide a dev environment to test managed app configuration so you will need to use one of the available 
MDM provider. This package was created to work with [Relution](https://relution.io).
You can create a free Account and enroll up to 5 devices to test your implementation.

For more information check out the documentation of the used MDM provider how to add managed app configuration to your app.

## How to use

To get managed app configuration call:
```dart
final managedConfig = ManagedConfigurations();
final managedAppConfig = await managedConfig.getManagedConfigurations;
```

To listen for managed app config changes subscribe to the stream:
```dart
...
managedConfig.mangedConfigurationsStream.listen((managedAppConfig){
    print(managedAppConfig);
});
```

### (Android) Report state with KeyedAppStatesReporter

For more info please checkout Android doc:
https://developer.android.com/reference/kotlin/androidx/enterprise/feedback/KeyedAppStatesReporter

```dart
...
managedConfig.reportKeyedAppStates("key", Severity.SEVERITY_INFO, "message","data");
```




