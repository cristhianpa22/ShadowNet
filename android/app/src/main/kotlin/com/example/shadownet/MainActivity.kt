package com.example.shadownet

import android.os.CancellationSignal
import androidx.biometric.BiometricPrompt
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterFragmentActivity() {

    private val channelName = "shadownet/biometric"
    private var failCount = 0
    private var resolved = false
    private var cancellationSignal: CancellationSignal? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "startBiometric" -> startBiometric(result)
                    else -> result.notImplemented()
                }
            }
    }

    private fun startBiometric(result: MethodChannel.Result) {
        failCount = 0
        resolved = false
        cancellationSignal = CancellationSignal()

        val executor = ContextCompat.getMainExecutor(this)

        lateinit var biometricPrompt: BiometricPrompt

        val callback = object : BiometricPrompt.AuthenticationCallback() {
            override fun onAuthenticationSucceeded(authResult: BiometricPrompt.AuthenticationResult) {
                if (resolved) return
                resolved = true
                result.success(mapOf("status" to "success", "attempts" to failCount))
            }

            override fun onAuthenticationFailed() {
                failCount++

                // Sigue abierto mientras failCount < 3
                if (failCount >= 3 && !resolved) {
                    resolved = true
                    biometricPrompt.cancelAuthentication() // cierra prompt automáticamente
                    result.success(mapOf("status" to "locked", "attempts" to failCount))
                }
            }

            override fun onAuthenticationError(errorCode: Int, errString: CharSequence) {
                if (resolved) return
                resolved = true
                result.success(
                    mapOf(
                        "status" to "error",
                        "code" to errorCode,
                        "message" to errString.toString(),
                        "attempts" to failCount
                    )
                )
            }
        }

        val promptInfo = BiometricPrompt.PromptInfo.Builder()
            .setTitle("Validación biométrica")
            .setSubtitle("Valida que tu ADN es humano")
            .setNegativeButtonText("Cancelar")
            .build()

        biometricPrompt = BiometricPrompt(this, executor, callback)
        biometricPrompt.authenticate(promptInfo)
    }
}