package io.mway.managed_configurations

import android.app.Activity
import android.content.*
import androidx.annotation.NonNull
import androidx.enterprise.feedback.KeyedAppState
import androidx.enterprise.feedback.KeyedAppStatesReporter
import com.google.gson.GsonBuilder
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.EventChannel.EventSink
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result


/** ManagedConfigurationsPlugin */
class ManagedConfigurationsPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
    private var channel: MethodChannel? = null
    private var eventChannel: EventChannel? = null
    private var eventSink: EventSink? = null
    private var activity: Activity? = null
    private val gson = GsonBuilder().registerTypeAdapterFactory(BundleTypeAdapterFactory())
        .create()

    private var reporter: KeyedAppStatesReporter? = null

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        reporter = KeyedAppStatesReporter.create(flutterPluginBinding.applicationContext)
        channel =
            MethodChannel(flutterPluginBinding.binaryMessenger, "managed_configurations_method")
        channel!!.setMethodCallHandler(this)

        eventChannel =
            EventChannel(flutterPluginBinding.binaryMessenger, "managed_configurations_event")
        eventChannel!!.setStreamHandler(
            object : EventChannel.StreamHandler {
                override fun onListen(args: Any?, sink: EventSink) {
                    eventSink = sink
                }

                override fun onCancel(args: Any?) {
                    eventSink = null
                }
            }
        )
        flutterPluginBinding.applicationContext.registerReceiver(
            restrictionsReceiver,
            IntentFilter(Intent.ACTION_APPLICATION_RESTRICTIONS_CHANGED)
        )
    }

    override fun onDetachedFromEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        reporter = null
        channel?.setMethodCallHandler(null)
        eventChannel?.setStreamHandler(null)
        flutterPluginBinding.applicationContext.unregisterReceiver(restrictionsReceiver)
    }

    override fun onAttachedToActivity(activityPluginBinding: ActivityPluginBinding) {
        activity = activityPluginBinding.activity
    }

    override fun onDetachedFromActivity() {
        activity = null
    }

    override fun onReattachedToActivityForConfigChanges(activityPluginBinding: ActivityPluginBinding) {
        activity = activityPluginBinding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activity = null
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            "getManagedConfigurations" -> getManagedConfigurations(result)
            "reportKeyedAppState" -> reportKeyedAppState(result, call)
            else -> result.notImplemented()
        }
    }

    private fun getManagedConfigurations(result: Result) {
        try {
            result.success(getApplicationRestrictions())
        } catch (e: Exception) {
            result.error("getManagedConfigurations", e.message, e.stackTrace)
        }
    }

    private fun reportKeyedAppState(result: Result, call: MethodCall) {
        try {
            val key = call.argument<String>("key")!!
            val severity = call.argument<Int>("severity")!!
            val message = call.argument<String>("message")
            val data = call.argument<String>("data")
            val states = hashSetOf(
                KeyedAppState.builder()
                    .setKey(key)
                    .setSeverity(severity)
                    .setMessage(message)
                    .setData(data)
                    .build()
            )
            reporter!!.setStatesImmediate(states, null)
            result.success(null)
        } catch (e: Exception) {
            result.error("reportKeyedAppState", e.message, e.stackTrace)
        }
    }

    private val restrictionsReceiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context, intent: Intent) {
            try {
                eventSink?.success(getApplicationRestrictions())
            } catch (e: Exception) {
                eventSink?.error("restrictionsReceiver", e.message, e.stackTrace)
            }
        }
    }

    private fun getApplicationRestrictions(): String {
        val restrictionManager =
            activity!!.getSystemService(Context.RESTRICTIONS_SERVICE) as RestrictionsManager
        val applicationRestrictions = restrictionManager.applicationRestrictions
        return gson.toJson(applicationRestrictions).toString()
    }
}