package au.com.mydomain.batterylevel

import android.content.Context
import android.content.ContextWrapper
import android.content.Intent
import android.content.IntentFilter
import android.os.BatteryManager
import android.os.Build.VERSION
import android.os.Build.VERSION_CODES

import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import kotlin.math.abs

class MainActivity: FlutterActivity() {
    // MethodChannel names - make sure that it matches the name
    // in main.dart
    // For part 1 mentioned in my LinkedIn article
    private val CHANNEL_FOR_BATTERY_LEVEL_API_CALL = "au.com.mydomain.batterylevel/battery"
    // For part 2 mentioned in my LinkedIn article
    private val CHANNEL_FOR_COMPUTATION_CALL = "au.com.mydomain.batterylevel/computation"

    // Set up the platform method call handler
    // to allow us to call the platform method
    // "getBatteryLevel" and "getComputationResult"
    // This is for part 1 mentioned in my LinkedIn article
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Set up platform method call handler - for part 1 mentioned in my LinkedIn article
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL_FOR_BATTERY_LEVEL_API_CALL).setMethodCallHandler {
                call, result ->
            // This method is invoked on the main thread.
            if (call.method == "getBatteryLevel") {
                val batteryLevel = getBatteryLevel()

                if (batteryLevel != -1) {
                    result.success(batteryLevel)
                } else {
                    result.error("UNAVAILABLE", "Battery level not available.", null)
                }
            } else {
                result.notImplemented()
            }
        }
        // Set up platform method call handler - for part 2 mentioned in my LinkedIn article
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL_FOR_COMPUTATION_CALL).setMethodCallHandler {
                call, result ->
            // This method is invoked on the main thread.
            if (call.method == "getComputationResult") {
                var computationResult : Int = 0 //Init var. - assume failure.

                // Unwrap the supplied JSON arguments to use in the computation.
                val comp = call.arguments as? Map<String, Any>
                val first:Int = comp?.get("compData_1") as Int
                val second:Int = comp?.get("compData_2") as Int

                if ((first != null) && (second != null)) {
                    computationResult = getComputationResult(first, second)
                }

                if (computationResult != 0) {
                    result.success(computationResult)
                } else {
                    result.error("UNAVAILABLE", "Computation result not available.", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }

    // This is the platform method which gets
    // called to return the percentage battery
    // level value as an integer.
    // We have different calls depending
    // on the platform Android versions
    // we are on. This is for part 1
    // mentioned in my LinkedIn article.
    private fun getBatteryLevel(): Int {
        val batteryLevel: Int
        // Material Design was first implemented in Android 5.0 API level 21
        if (VERSION.SDK_INT >= VERSION_CODES.LOLLIPOP) {
            val batteryManager = getSystemService(Context.BATTERY_SERVICE) as BatteryManager
            batteryLevel = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)
        } else {
            // Versions below Android 5.0 API level 21 did not use Material Design.
            val intent = ContextWrapper(applicationContext).registerReceiver(null, IntentFilter(Intent.ACTION_BATTERY_CHANGED))
            batteryLevel = intent!!.getIntExtra(BatteryManager.EXTRA_LEVEL, -1) * 100 / intent.getIntExtra(BatteryManager.EXTRA_SCALE, -1)
        }
        return batteryLevel
    }

    // This is the platform method which gets
    // called to return the computation result.
    // Return 0 on any error. Usually error conditions are
    // signified by returning -1 but here we are returning 0
    // on error for simplicity.
    // This is for part 2 mentioned in my LinkedIn article
    private fun getComputationResult(x:Int, y:Int): Int {
        var compResult:Int = 0  // Init - assume failure.
        try {
            compResult = x*y
        } catch (ex: Exception) {
            return 0
        }
        return abs(compResult)
    }
}
