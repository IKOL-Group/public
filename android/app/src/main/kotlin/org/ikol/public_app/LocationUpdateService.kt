package org.ikol.public_app

import android.app.IntentService
import android.content.Intent
import android.location.Location
import android.util.Log
import com.google.android.gms.location.LocationResult
import kotlinx.serialization.Serializable
import kotlinx.serialization.encodeToString
import kotlinx.serialization.json.Json
import java.io.DataOutputStream
import java.net.HttpURLConnection
import java.net.URL
import java.nio.charset.StandardCharsets


@Serializable
data class MyModel(val latitude: Double, val longitude: Double, val time: Long) {
    constructor(location: Location) : this(location.latitude, location.longitude, location.time)
}


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
        Log.d(TAG, locationResult.locations.toString())
//        log(TAG, Json.encodeToString(MyModel.serializer(), MyModel(locationResult.lastLocation)))
        log(TAG, Json.encodeToString(MyModel(locationResult.lastLocation)))
        Log.d(TAG, Json.encodeToString(MyModel(locationResult.lastLocation)))

        // Remember that this is the background thread already
    }

    private fun log(tag: String, message: String) {
        val thread = Thread {
            try {
                val mURL = URL("http://192.168.0.101:8080/")

                with(mURL.openConnection() as HttpURLConnection) {
                    // optional default is GET
                    requestMethod = "POST"

                    val postData: ByteArray = if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.KITKAT) {
                        message.toByteArray(StandardCharsets.UTF_8)
                    } else {
                        TODO("VERSION.SDK_INT < KITKAT")
                    }

//                    https://stackoverflow.com/a/49191766/8608146

                    setRequestProperty("charset", "utf-8")
                    setRequestProperty("Content-length", postData.size.toString())
                    setRequestProperty("Content-Type", "application/json")

                    try {
                        val outputStream = DataOutputStream(outputStream)
                        outputStream.write(postData)
                        outputStream.flush()
                    } catch (exception: Exception) {
                        println("Failed to send request: ${exception.message}")
                    }

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