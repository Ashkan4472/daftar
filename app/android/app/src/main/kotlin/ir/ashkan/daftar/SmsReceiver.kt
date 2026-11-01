package ir.ashkan.daftar

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent

/** New SMS arrived: schedule a sync. The message itself is read from the inbox. */
class SmsReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        SyncWorker.runSoon(context)
    }
}
