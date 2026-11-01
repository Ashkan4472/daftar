package ir.ashkan.daftar

import android.Manifest
import android.content.Context
import android.content.pm.PackageManager
import android.provider.Telephony
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel
import java.util.concurrent.Executors

/**
 * SMS inbox access for the Dart importer. Works with only a Context so the
 * background sync worker can use it too.
 *
 * Channel `daftar/sms`:
 * - hasPermission() -> Boolean
 * - count(from, to) -> Int
 * - query(from, to, offset, limit) -> List<Map{address, body, date}> ascending by date;
 *   from/to are epoch ms, `to` exclusive.
 */
class SmsChannel(private val context: Context) {
    private val io = Executors.newSingleThreadExecutor()
    private val inbox = Telephony.Sms.Inbox.CONTENT_URI
    private val where = "${Telephony.Sms.DATE} >= ? AND ${Telephony.Sms.DATE} < ?"

    fun hasPermission() =
        context.checkSelfPermission(Manifest.permission.READ_SMS) == PackageManager.PERMISSION_GRANTED

    fun register(messenger: BinaryMessenger): MethodChannel {
        val channel = MethodChannel(messenger, "daftar/sms")
        channel.setMethodCallHandler { call, result ->
            when (call.method) {
                "hasPermission" -> result.success(hasPermission())
                "count", "query" -> {
                    if (!hasPermission()) {
                        result.error("permission", "READ_SMS not granted", null)
                        return@setMethodCallHandler
                    }
                    val from = call.argument<Number>("from")!!.toLong()
                    val to = call.argument<Number>("to")!!.toLong()
                    val offset = call.argument<Int>("offset") ?: 0
                    val limit = call.argument<Int>("limit") ?: 500
                    io.execute {
                        try {
                            val out: Any = if (call.method == "count") count(from, to) else query(from, to, offset, limit)
                            android.os.Handler(android.os.Looper.getMainLooper()).post { result.success(out) }
                        } catch (e: Exception) {
                            android.os.Handler(android.os.Looper.getMainLooper()).post { result.error("query", e.message, null) }
                        }
                    }
                }
                else -> result.notImplemented()
            }
        }
        return channel
    }

    private fun count(from: Long, to: Long): Int =
        context.contentResolver.query(inbox, arrayOf(Telephony.Sms._ID), where,
            arrayOf(from.toString(), to.toString()), null)?.use { it.count } ?: 0

    private fun query(from: Long, to: Long, offset: Int, limit: Int): List<Map<String, Any?>> {
        val rows = ArrayList<Map<String, Any?>>(limit)
        context.contentResolver.query(
            inbox,
            arrayOf(Telephony.Sms.ADDRESS, Telephony.Sms.BODY, Telephony.Sms.DATE),
            where,
            arrayOf(from.toString(), to.toString()),
            "${Telephony.Sms.DATE} ASC, ${Telephony.Sms._ID} ASC",
        )?.use { c ->
            if (!c.moveToPosition(offset)) return rows
            do {
                rows.add(mapOf("address" to c.getString(0), "body" to c.getString(1), "date" to c.getLong(2)))
            } while (rows.size < limit && c.moveToNext())
        }
        return rows
    }
}
