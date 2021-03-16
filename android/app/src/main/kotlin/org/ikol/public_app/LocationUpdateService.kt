package org.ikol.public_app

import android.app.IntentService
import android.content.Intent
import android.util.Log
import com.google.android.gms.location.LocationResult
import java.io.OutputStreamWriter
import java.net.HttpURLConnection
import java.net.URL
import java.net.URLEncoder

class LocationUpdateService : IntentService(TAG) {
    override fun onHandleIntent(intent: Intent?) {
        if (intent != null) {
            val action = intent.action
            if (action != null) {
                if (ACTION_HANDLE_LOCATION == action) {
                    onActionHandleLocation(intent)
                } else {
                    Log.w(TAG, "onHandleIntent(), unhandled action: $action")
                }
            }
        }
    }

    private fun onActionHandleLocation(intent: Intent) {
        if (!LocationResult.hasResult(intent)) {
            Log.w(TAG, "No location result in supplied intent")
            return
        }
        val locationResult = LocationResult.extractResult(intent)

        // TODO send to server using a blocking request.
        Log.d(TAG, locationResult.toString())
        log(TAG, locationResult.toString())

        // Remember that this is the background thread already
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
        private const val TAG = "LocationUpdateService"
        const val ACTION_HANDLE_LOCATION = "ACTION_HANDLE_LOCATION"
    }
}