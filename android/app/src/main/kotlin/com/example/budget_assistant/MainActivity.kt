package com.example.budget_assistant

import android.content.ContentUris
import android.content.ContentValues
import android.os.Build
import android.os.Environment
import android.os.Handler
import android.os.Looper
import android.provider.MediaStore
import android.view.WindowManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File

class MainActivity: FlutterActivity() {

    private val handler = Handler(Looper.getMainLooper())
    private var secureRestoreRunnable: Runnable? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Сохранение экспорта в Downloads/BudgetAssistant (Этап 12.8).
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "budget_assistant/clock"
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "saveToDownloads" -> {
                    val fileName = call.argument<String>("fileName") ?: "export.bin"
                    val bytes = call.argument<ByteArray>("bytes")
                    val mime = call.argument<String>("mime") ?: "application/octet-stream"
                    if (bytes == null) {
                        result.error("EMPTY", "No bytes provided", null)
                        return@setMethodCallHandler
                    }
                    try {
                        val saved = saveToDownloads(fileName, bytes, mime)
                        result.success(saved)
                    } catch (e: Exception) {
                        result.error("SAVE_FAILED", e.message, null)
                    }
                }
                else -> result.notImplemented()
            }
        }

        // FLAG_SECURE: временное снятие для шеринга (Этап 19, ТОМ 3 §6).
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "budget_assistant/secure_flag"
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "disableTemporarily" -> {
                    val ms = call.argument<Number>("durationMs")?.toLong() ?: 5000L
                    val wasSecure = isSecureNow()
                    if (wasSecure) {
                        applySecure(false)
                        secureRestoreRunnable?.let { handler.removeCallbacks(it) }
                        val runnable = Runnable { applySecure(true) }
                        secureRestoreRunnable = runnable
                        handler.postDelayed(runnable, ms)
                    }
                    result.success(wasSecure)
                }
                "restoreSecure" -> {
                    secureRestoreRunnable?.let { handler.removeCallbacks(it) }
                    applySecure(true)
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun isSecureNow(): Boolean {
        return (window.attributes.flags and WindowManager.LayoutParams.FLAG_SECURE) != 0
    }

    private fun applySecure(on: Boolean) {
        if (on) {
            window.addFlags(WindowManager.LayoutParams.FLAG_SECURE)
        } else {
            window.clearFlags(WindowManager.LayoutParams.FLAG_SECURE)
        }
    }

    private fun saveToDownloads(fileName: String, bytes: ByteArray, mime: String): String {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            val resolver = contentResolver
            val values = ContentValues().apply {
                put(MediaStore.Downloads.DISPLAY_NAME, fileName)
                put(MediaStore.Downloads.MIME_TYPE, mime)
                put(
                    MediaStore.Downloads.RELATIVE_PATH,
                    Environment.DIRECTORY_DOWNLOADS + "/BudgetAssistant"
                )
            }
            // Удаляем старый файл с тем же именем, чтобы не плодить копии.
            resolver.query(
                MediaStore.Downloads.EXTERNAL_CONTENT_URI,
                arrayOf(MediaStore.Downloads._ID),
                MediaStore.Downloads.DISPLAY_NAME + "=?",
                arrayOf(fileName),
                null
            )?.use { cursor ->
                if (cursor.moveToFirst()) {
                    val id = cursor.getLong(0)
                    resolver.delete(
                        ContentUris.withAppendedId(
                            MediaStore.Downloads.EXTERNAL_CONTENT_URI, id
                        ), null, null
                    )
                }
            }
            val uri = resolver.insert(MediaStore.Downloads.EXTERNAL_CONTENT_URI, values)
                ?: throw IllegalStateException("MediaStore insert failed")
            resolver.openOutputStream(uri)?.use { it.write(bytes) }
                ?: throw IllegalStateException("OutputStream failed")
            return "Downloads/BudgetAssistant/" + fileName
        }
        @Suppress("DEPRECATION")
        val dir = File(
            Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS),
            "BudgetAssistant"
        )
        if (!dir.exists()) dir.mkdirs()
        val file = File(dir, fileName)
        file.writeBytes(bytes)
        return file.absolutePath
    }
}