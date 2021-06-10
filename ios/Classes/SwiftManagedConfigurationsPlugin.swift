import Flutter
import UIKit

/**
ManagedConfiguration Plugin iOS:
 */
public class SwiftManagedConfigurationsPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    //method channel
    let channel = FlutterMethodChannel(name: "managed_configurations_method", binaryMessenger: registrar.messenger())
    // event channel
    let eventChannel = FlutterEventChannel(name: "managed_configurations_event", binaryMessenger: registrar.messenger())
            eventChannel.setStreamHandler(SwiftStreamHandler())
    
    let instance = SwiftManagedConfigurationsPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
    
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    guard call.method == "getManagedConfigurations" else {
             result(FlutterMethodNotImplemented)
             return
           }
           self.getManagedConfiguration(result: result)
  }
    
    /**
    Handles the getManagedConfiguration method ivoked by flutter side.
    Writes the managed configuration in the result as json converted to String
     If something fails returns empty json string ("{}")
     */
    private func getManagedConfiguration(result: FlutterResult){
        if let dict = UserDefaults.standard.dictionary(forKey: "com.apple.configuration.managed"){
            if let jsonData = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted){
                if let jsonString = String(data: jsonData, encoding: .utf8) {
                    result(jsonString)
                }

            }
            result("{}")
        }
        result("{}")
    }
    
   

}

/**
 Used to handle the Event channel
 On Flutter stream subscribe creates an observer on UsersDefault.
 Calls on changes the mdConfigChange method
 Its not necassary to remove this observer as it will anyway removed if not used
 */
class SwiftStreamHandler: NSObject, FlutterStreamHandler {
    /// save the sink as we need it to put the changes in it
    var eventsVariable: FlutterEventSink?
    /// save the last result to identify real changes
    var lastJsonString: String?
    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        eventsVariable = events
        NotificationCenter.default.addObserver(self,selector: #selector(mdmConfigChange),name: UserDefaults.didChangeNotification,object: nil)
        return nil
    }

    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        return nil
    }
    
    /**
     handles the notification if something happend on UserDefaults
     Extracts the managed configuration and converts them to json String. Checks if something changed.
     If so, puts in the sink (Flutter side will be notified)
     */
    @objc func mdmConfigChange() -> Void {
        if let managedConf = UserDefaults.standard.object(forKey: "com.apple.configuration.managed") as? [String:Any],
           let jsonData = try? JSONSerialization.data(withJSONObject: managedConf, options: .prettyPrinted),
           let jsonString = String(data: jsonData, encoding: .utf8),
           let events = eventsVariable{
            print("calling dies das")
            if lastJsonString == nil {
                lastJsonString = jsonString
                events(jsonString)
            }else if(jsonString != lastJsonString){
                lastJsonString = jsonString;
                events(jsonString)
            }
            
        }
    }
}
