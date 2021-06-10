package io.mway.managed_configurations

import android.app.Activity
import android.content.*
import android.util.Log
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.EventChannel.EventSink
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import org.json.JSONException
import org.json.JSONObject


/** ManagedConfigurationsPlugin */
class ManagedConfigurationsPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel

    ///
    ///EventChannel which will be used to provide Event to Flutter part
    ///
    private lateinit var eventChannel: EventChannel
    private lateinit var eventStreamHandler: EventChannel.StreamHandler


    private lateinit var context: Context
    private lateinit var activity: Activity


    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        context = flutterPluginBinding.applicationContext

        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "managed_configurations_method")
        channel.setMethodCallHandler(this)

        eventChannel = EventChannel(flutterPluginBinding.binaryMessenger, "managed_configurations_event");


        val restrictionsFilter = IntentFilter(Intent.ACTION_APPLICATION_RESTRICTIONS_CHANGED)

        eventChannel.setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(p0: Any?, p1: EventSink) {

                //Create an broadcast receiver
                val restrictionsReceiver = object : BroadcastReceiver() {
                    override fun onReceive(context: Context, intent: Intent) {
                        var restrictionManager = activity.getSystemService(Context.RESTRICTIONS_SERVICE) as RestrictionsManager
                        // Get the current configuration bundle
                        val appRestrictions = restrictionManager.applicationRestrictions
                        val json = JSONObject()
                        val keys: Set<String> = appRestrictions.keySet()
                        for (key in keys) {
                            try {
                                json.put(key, JSONObject.wrap(appRestrictions.get(key)))
                            } catch (e: JSONException) {
                                Log.d("Managed_Configuration", "Failed to put value with key: $key into JSONObject")
                            }
                        }
                        p1.success(json.toString())
                    }
                }
                context.registerReceiver(restrictionsReceiver, restrictionsFilter)
            }

            override fun onCancel(p0: Any?) {}
        }
        )


    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        var restrictionManager = activity.getSystemService(Context.RESTRICTIONS_SERVICE) as RestrictionsManager
        if (call.method == "getManagedConfigurations") {
            val json = JSONObject()
            val keys: Set<String> = restrictionManager.applicationRestrictions.keySet()
            for (key in keys) {
                try {
                    json.put(key, JSONObject.wrap(restrictionManager.applicationRestrictions.get(key)))
                } catch (e: JSONException) {
                    Log.d("Managed_Configuration", "Failed to put value with key: $key into JSONObject")
                }
            }
            result.success(json.toString())
        } else {
            result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onDetachedFromActivity() {
        TODO("Not yet implemented")
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        TODO("Not yet implemented")
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity;
    }

    override fun onDetachedFromActivityForConfigChanges() {
        TODO("Not yet implemented")
    }
}



