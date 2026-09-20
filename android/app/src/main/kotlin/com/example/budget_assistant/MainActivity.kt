package com.example.budget_assistant

import android.content.ContentValues
import android.os.Environment
import android.os.SystemClock
import android.provider.MediaStore
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "budget_assistant/clock"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "getElapsedRealtime" -> result.success(SystemClock.elapsedRealtime())
                    "saveToDownloads" -> saveToDownloads(call, result)
                    else -> result.notImplemented()
                }
            }
    }

    private fun saveToDownloads(call: MethodCall, result: MethodChannel.Result) {
        val fileName = call.argument<String>("fileName")
        val bytes = call.argument<ByteArray>("bytes")
        val mime = call.argument<String>("mime") ?: "application/octet-stream"
        if (fileName == null || bytes == null) {
            result.error("400", "fileName/bytes required", null)
            return
        }
        try {
            val values = ContentValues().apply {
                put(MediaStore.Downloads.DISPLAY_NAME, fileName)
                put(MediaStore.Downloads.MIME_TYPE, mime)
                put(
                    MediaStore.Downloads.RELATIVE_PATH,
                    Environment.DIRECTORY_DOWNLOADS + "/BudgetAssistant"
                )
            }
            val uri = contentResolver.insert(MediaStore.Downloads.EXTERNAL_CONTENT_URI, values)
            if (uri == null) {
                result.error("500", "MediaStore insert failed", null)
                return
            }
            contentResolver.openOutputStream(uri)?.use { it.write(bytes) }
            result.success(uri.toString())
        } catch (e: Exception) {
            result.error("500", e.message, null)
        }
    }
}