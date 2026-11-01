package ir.ashkan.daftar

import android.Manifest
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.os.PowerManager
import android.provider.Settings
import android.view.WindowManager
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterFragmentActivity() {
    private var pendingPermission: MethodChannel.Result? = null
    private var channel: MethodChannel? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        instance = this
        val ch = SmsChannel(this).register(flutterEngine.dartExecutor.binaryMessenger)
        channel = ch
        // Permission and system helpers live here because they need an Activity.
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "daftar/system").setMethodCallHandler { call, result ->
            when (call.method) {
                "requestSmsPermission" -> {
                    if (hasSms()) result.success(true) else {
                        pendingPermission = result
                        requestPermissions(arrayOf(Manifest.permission.READ_SMS, Manifest.permission.RECEIVE_SMS), REQ_SMS)
                    }
                }
                "setLiveSync" -> {
                    if (call.argument<Boolean>("enabled") == true) SyncWorker.ensurePeriodic(this) else SyncWorker.cancelPeriodic(this)
                    result.success(null)
                }
                "syncNow" -> { SyncWorker.runSoon(this); result.success(null) }
                "isIgnoringBatteryOptimizations" ->
                    result.success((getSystemService(POWER_SERVICE) as PowerManager).isIgnoringBatteryOptimizations(packageName))
                "openBatterySettings" -> {
                    startActivity(Intent(Settings.ACTION_REQUEST_IGNORE_BATTERY_OPTIMIZATIONS, Uri.parse("package:$packageName")))
                    result.success(null)
                }
                "setSecure" -> {
                    if (call.argument<Boolean>("secure") == true) window.addFlags(WindowManager.LayoutParams.FLAG_SECURE)
                    else window.clearFlags(WindowManager.LayoutParams.FLAG_SECURE)
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun hasSms() =
        checkSelfPermission(Manifest.permission.READ_SMS) == PackageManager.PERMISSION_GRANTED

    override fun onRequestPermissionsResult(code: Int, perms: Array<out String>, grants: IntArray) {
        super.onRequestPermissionsResult(code, perms, grants)
        if (code == REQ_SMS) {
            pendingPermission?.success(hasSms())
            pendingPermission = null
        }
    }

    override fun onDestroy() {
        if (instance === this) instance = null
        super.onDestroy()
    }

    companion object {
        private const val REQ_SMS = 4201
        private var instance: MainActivity? = null

        /** Tells a running UI that the background worker wrote new data. */
        fun notifySynced() {
            instance?.channel?.invokeMethod("synced", null)
        }
    }
}
