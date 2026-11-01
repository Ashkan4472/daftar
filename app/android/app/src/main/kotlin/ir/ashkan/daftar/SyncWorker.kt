package ir.ashkan.daftar

import android.content.Context
import android.os.Handler
import android.os.Looper
import androidx.work.Constraints
import androidx.work.ExistingPeriodicWorkPolicy
import androidx.work.ExistingWorkPolicy
import androidx.work.OneTimeWorkRequestBuilder
import androidx.work.PeriodicWorkRequestBuilder
import androidx.work.WorkManager
import androidx.work.Worker
import androidx.work.WorkerParameters
import io.flutter.FlutterInjector
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.plugin.common.MethodChannel
import java.util.concurrent.CountDownLatch
import java.util.concurrent.TimeUnit

/** Runs Dart entrypoint `backgroundSync` in a headless engine and waits for it. */
class SyncWorker(context: Context, params: WorkerParameters) : Worker(context, params) {
    override fun doWork(): Result {
        val latch = CountDownLatch(1)
        val main = Handler(Looper.getMainLooper())
        var engine: FlutterEngine? = null
        main.post {
            val loader = FlutterInjector.instance().flutterLoader()
            loader.startInitialization(applicationContext)
            loader.ensureInitializationComplete(applicationContext, null)
            val e = FlutterEngine(applicationContext)
            engine = e
            SmsChannel(applicationContext).register(e.dartExecutor.binaryMessenger)
            MethodChannel(e.dartExecutor.binaryMessenger, "daftar/bg").setMethodCallHandler { call, result ->
                if (call.method == "done") {
                    result.success(null)
                    latch.countDown()
                } else result.notImplemented()
            }
            e.dartExecutor.executeDartEntrypoint(
                DartExecutor.DartEntrypoint(loader.findAppBundlePath(), "backgroundSync"))
        }
        val finished = latch.await(90, TimeUnit.SECONDS)
        main.post {
            engine?.destroy()
            MainActivity.notifySynced()
        }
        return if (finished) Result.success() else Result.retry()
    }

    companion object {
        private const val ONCE = "daftar-sync-once"
        private const val PERIODIC = "daftar-sync-periodic"

        /** Sync shortly after an SMS arrives (the inbox row can lag the broadcast). */
        fun runSoon(context: Context) {
            val req = OneTimeWorkRequestBuilder<SyncWorker>().setInitialDelay(3, TimeUnit.SECONDS).build()
            WorkManager.getInstance(context).enqueueUniqueWork(ONCE, ExistingWorkPolicy.REPLACE, req)
        }

        /** Safety net: also sync every 15 minutes in case a broadcast is missed. */
        fun ensurePeriodic(context: Context) {
            val req = PeriodicWorkRequestBuilder<SyncWorker>(15, TimeUnit.MINUTES)
                .setConstraints(Constraints.NONE).build()
            WorkManager.getInstance(context).enqueueUniquePeriodicWork(PERIODIC, ExistingPeriodicWorkPolicy.KEEP, req)
        }

        fun cancelPeriodic(context: Context) {
            WorkManager.getInstance(context).cancelUniqueWork(PERIODIC)
        }
    }
}
