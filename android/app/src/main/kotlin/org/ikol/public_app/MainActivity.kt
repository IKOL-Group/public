package org.ikol.public_app

import android.content.Intent
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import org.ikol.public_app.map.MapActivity
import java.io.OutputStreamWriter
import java.net.HttpURLConnection
import java.net.URL
import java.net.URLEncoder

class MainActivity: FlutterActivity() {

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            call, result ->
            when (call.method) {
                "openActivity" -> {
                    val intent = Intent(this, MapActivity::class.java)
                    startActivity(intent)
                }
                else -> {
                    result.error("NOT_FOUND", "no such method", call.method)
                }
            }
        }
    }

    private fun log(tag: String, message: String) {
        val thread = Thread {
            try {
                var reqParam = URLEncoder.encode("tag", "UTF-8") + "=" + URLEncoder.encode(tag, "UTF-8")
                reqParam += "&" + URLEncoder.encode("message", "UTF-8") + "=" + URLEncoder.encode(message, "UTF-8")
                val mURL = URL("http://192.168.0.101:8080/")

                with(mURL.openConnection() as HttpURLConnection) {
                    // optional default is GET
                    requestMethod = "POST"

                    val wr = OutputStreamWriter(outputStream)
                    wr.write(reqParam)
                    wr.flush()

                    println("URL : $url")
                    println("Response Code : $responseCode")
                }
            } catch (e: Exception) {
                e.printStackTrace()
            }
        }

        thread.start()
    }

    companion object {
        private const val CHANNEL = "org.ikol.public_app/open"
    }

}
