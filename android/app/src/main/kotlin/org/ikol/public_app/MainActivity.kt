package org.ikol.public_app

import io.flutter.embedding.android.FlutterActivity
import java.io.OutputStreamWriter
import java.net.HttpURLConnection
import java.net.URL
import java.net.URLEncoder

class MainActivity: FlutterActivity() {
//    private fun log(tag: String, message: String) {
//        val thread = Thread {
//            try {
//                var reqParam = URLEncoder.encode("tag", "UTF-8") + "=" + URLEncoder.encode(tag, "UTF-8")
//                reqParam += "&" + URLEncoder.encode("message", "UTF-8") + "=" + URLEncoder.encode(message, "UTF-8")
//                val mURL = URL("http://192.168.0.101:8080/")
//
//                with(mURL.openConnection() as HttpURLConnection) {
//                    // optional default is GET
//                    requestMethod = "POST"
//
//                    val wr = OutputStreamWriter(outputStream)
//                    wr.write(reqParam)
//                    wr.flush()
//
//                    println("URL : $url")
//                    println("Response Code : $responseCode")
//                }
//            } catch (e: Exception) {
//                e.printStackTrace()
//            }
//        }
//
//        thread.start()
//    }
}
