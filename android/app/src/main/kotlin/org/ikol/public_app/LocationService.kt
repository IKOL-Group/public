package org.ikol.public_app

import android.Manifest
import android.app.*
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.graphics.Color
import android.location.Location
import android.os.Build
import android.os.IBinder
import android.os.Looper
import android.util.Log
import androidx.annotation.RequiresApi
import androidx.core.app.NotificationCompat
import androidx.core.content.ContextCompat
import com.google.android.gms.location.*
import kotlinx.serialization.Serializable
import kotlinx.serialization.encodeToString
import kotlinx.serialization.json.Json
import org.ikol.public_app.receiver.RestartBackgroundService
import java.io.DataOutputStream
import java.net.HttpURLConnection
import java.net.URL


@Serializable
data class Location2(val latitude: Double, val longitude: Double)

@Serializable
data class UpdateEvent(val location: Location2, val publicUserID: String, val businessName: String) {
//    format =  `{
//        "location": {
//            "longitude" : 32.193122,
//            "latitude" : 45.4312
//        },
//        "publicUserId" : "60487ad389ca20853d93630e",
//        "businessName" : "DeliveryBoyz"
//    }`
}

class LocationService : Service() {
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    lateinit var userId: String
    private lateinit var mFusedLocationClient: FusedLocationProviderClient
    private lateinit var locationCallback: LocationCallback

    override fun onCreate() {
        super.onCreate()


        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            createNotificationChanel()
        } else {
            val nf = Notification()
            val intent = Intent(this, MainActivity::class.java)
            val pendingIntent = PendingIntent.getActivity(this, 267, intent, PendingIntent.FLAG_UPDATE_CURRENT)
            nf.contentIntent = pendingIntent
            startForeground(
                    1,
                    nf
            )
        }
        mFusedLocationClient =
                LocationServices.getFusedLocationProviderClient(this)
        locationCallback = object : LocationCallback() {
            override fun onLocationResult(locationResult: LocationResult) {
                val location: Location = locationResult.lastLocation
                latitude = location.latitude
                longitude = location.longitude
                Log.d("LocationService", "location update $location")
                updateLocationInServer(latitude, longitude)
            }
        }
        requestLocationUpdates()
    }

    @RequiresApi(Build.VERSION_CODES.O)
    private fun createNotificationChanel() {
        val channelName = "Background Service"
        val chan = NotificationChannel(
                NOTIFICATION_CHANNEL_ID,
                channelName,
                NotificationManager.IMPORTANCE_NONE
        )
        chan.lightColor = Color.BLUE
        chan.lockscreenVisibility = Notification.VISIBILITY_PRIVATE

        val manager =
                (getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager)
        manager.createNotificationChannel(chan)

        val notificationBuilder =
                NotificationCompat.Builder(this, NOTIFICATION_CHANNEL_ID)

//        https://github.com/phanirithvij/Geofence-sample-kt/blob/main/app/src/main/java/com/example/geofencing/NotificationHelper.kt#L31

        val intent = Intent(applicationContext, MainActivity::class.java).apply {
            flags = Intent.FLAG_ACTIVITY_REORDER_TO_FRONT
        }
        val pendingIntent = PendingIntent.getActivity(this, 0, intent, PendingIntent.FLAG_UPDATE_CURRENT)
        val notification: Notification = notificationBuilder.apply {
            setContentTitle("Location sharing is on")
            setContentIntent(pendingIntent)
//            TODO in private_app use this instead of using multiple notification channels
            setOnlyAlertOnce(true)
            setSmallIcon(R.mipmap.ic_launcher)
            priority = NotificationManager.IMPORTANCE_MAX
            setCategory(Notification.CATEGORY_SERVICE)
            setAutoCancel(false)
            setOngoing(true)
        }.build()

        startForeground(2, notification)
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        userId = intent?.getStringExtra("id") ?: "604a724263d642654fd8b333";
        super.onStartCommand(intent, flags, startId)
        Log.d(TAG, intent?.action.toString())
        return START_STICKY
    }

    override fun onDestroy() {
        super.onDestroy()

//        https://stackoverflow.com/a/13558642/8608146
        val sharedPref =
                getSharedPreferences(getString(R.string.preference_file_key), Context.MODE_PRIVATE)

        val fullStop: Boolean = sharedPref.getBoolean(getString(R.string.user_stopped_service), false)
        with(sharedPref.edit()) {
//            TODO set it to false or remove?
            remove(getString(R.string.user_stopped_service))
            apply()
        }

        stopLocationUpdates()

        if (fullStop) return

//        Restart service if app is closed normally
        val broadcastIntent = Intent()
        broadcastIntent.action = "restartservice"
        broadcastIntent.setClass(this, RestartBackgroundService::class.java)
        sendBroadcast(broadcastIntent)
    }

    fun updateLocationInServer(latitude: Double, longitude: Double) {
//        https://github.com/IKOL-Group/public/blob/4ffb43fa68997b36c4134753636cb09be13ccce0/android/app/src/main/kotlin/org/ikol/public_app/LocationUpdateService.kt#L53
        val thread = Thread {
            try {
                //val baseURL = "http://192.168.0.101:3000"
                val baseURL = "https://boul.in";
                val mURL = URL("$baseURL/location/public/actions/update")

                with(mURL.openConnection() as HttpURLConnection) {
                    requestMethod = "PUT"
                    println("userIDD "+userId)
                    val event = UpdateEvent(Location2(latitude, longitude), userId, "DeliveryBoyz")
                    val message = Json.encodeToString(event)
                    println(message)

                    val postData: ByteArray =
                            message.toByteArray(Charsets.UTF_8)

                    // https://stackoverflow.com/a/49191766/8608146

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
                    println("Response : $responseMessage")
                }
            } catch (e: Exception) {
                e.printStackTrace()
            }
        }

        thread.start()
    }

    override fun onBind(intent: Intent?): IBinder? {
        return null
    }

    private fun requestLocationUpdates() {
        val request = LocationRequest.create()
        request.interval = 8000
        request.fastestInterval = 7000
        request.priority = LocationRequest.PRIORITY_HIGH_ACCURACY

        val permission = ContextCompat.checkSelfPermission(
                this,
                Manifest.permission.ACCESS_FINE_LOCATION
        )
        if (permission == PackageManager.PERMISSION_GRANTED) { // Request location updates and when an update is
            // received, store the location in Firebase
            mFusedLocationClient.requestLocationUpdates(request, locationCallback, Looper.myLooper()!!)
        }
    }

    private fun stopLocationUpdates() {
        mFusedLocationClient.removeLocationUpdates(locationCallback)
    }

    companion object {
        private const val TAG = "LocationService"
        private const val NOTIFICATION_CHANNEL_ID = "com.getlocationbackground"
    }
}