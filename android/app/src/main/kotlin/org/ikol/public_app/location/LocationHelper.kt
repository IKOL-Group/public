package org.ikol.public_app.location

import android.Manifest
import android.app.Activity
import android.content.Context
import android.content.ContextWrapper
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Build
import android.util.Log
import android.widget.Toast
import androidx.appcompat.app.AlertDialog
import androidx.core.app.ActivityCompat
import org.ikol.public_app.LocationService
import org.ikol.public_app.R
import org.ikol.public_app.util.Util

class LocationHelper(private var mActivity: Activity, base: Context) : ContextWrapper(base) {
    private var mLocationService: LocationService = LocationService()
    private lateinit var mServiceIntent: Intent

    fun isLocationEnabled() {
        if (!Util.isLocationEnabledOrNot(mActivity)) {
            Util.showAlertLocation(
                    mActivity,
                    getString(R.string.gps_enable),
                    getString(R.string.please_turn_on_gps),
                    getString(R.string.ok)
            )
        }
    }

    fun shouldShowRequestPermissionRationale(): Boolean {
        return ActivityCompat.shouldShowRequestPermissionRationale(
                mActivity,
                Manifest.permission.ACCESS_FINE_LOCATION
        )
    }

    //    https://github.com/IKOL-Group/public/blob/d77cb83805db901a952b9caf9a1d2670301a6520/android/app/src/main/kotlin/org/ikol/public_app/map/MapActivity.kt#L79
    fun checkLocationPermissions() {
        if (ActivityCompat.checkSelfPermission(
                        this,
                        Manifest.permission.ACCESS_FINE_LOCATION
                ) != PackageManager.PERMISSION_GRANTED
        ) {
            // Should we show an explanation?
            if (ActivityCompat.shouldShowRequestPermissionRationale(
                            mActivity,
                            Manifest.permission.ACCESS_FINE_LOCATION
                    )
            ) {
                Log.d("TAGGERS", ActivityCompat.shouldShowRequestPermissionRationale(
                        mActivity,
                        Manifest.permission.ACCESS_FINE_LOCATION
                ).toString())
                // Show an explanation to the user *asynchronously* -- don't block
                // this thread waiting for the user's response! After the user
                // sees the explanation, try again to request the permission.
                AlertDialog.Builder(mActivity)
                        .setTitle("Location Permission Needed")
                        .setMessage("This app needs the Location permission, please accept to use location functionality")
                        .setPositiveButton(
                                "OK"
                        ) { _, _ ->
                            Log.d("TAG", Build.VERSION.SDK_INT.toString())
                            //Prompt the user once explanation has been shown
                            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                                mActivity.requestPermissions(
                                        arrayOf(
                                                Manifest.permission.ACCESS_FINE_LOCATION,
                                                Manifest.permission.ACCESS_BACKGROUND_LOCATION,
                                        ),
                                        FINE_BACKGROUND_LOCATION_ACCESS_REQUEST_CODE
                                )
                            } else {
                                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                                    mActivity.requestPermissions(
                                            arrayOf(Manifest.permission.ACCESS_FINE_LOCATION),
                                            FINE_LOCATION_ACCESS_REQUEST_CODE
                                    )
                                }
                            }
                        }
                        .create()
                        .show()
            } else {
                // No explanation needed, we can request the permission.
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                    mActivity.requestPermissions(
                            arrayOf(Manifest.permission.ACCESS_FINE_LOCATION, Manifest.permission.ACCESS_BACKGROUND_LOCATION),
                            FINE_BACKGROUND_LOCATION_ACCESS_REQUEST_CODE
                    )
                } else {
                    ActivityCompat.requestPermissions(
                            mActivity,
                            arrayOf(Manifest.permission.ACCESS_FINE_LOCATION),
                            FINE_LOCATION_ACCESS_REQUEST_CODE
                    )
                }
            }
        }
    }

    fun startSharing() {
//        mLocationService = LocationService()
        mServiceIntent = Intent(this, mLocationService::class.java)
        if (!Util.isMyServiceRunning(mLocationService::class.java, mActivity)) {
            startService(mServiceIntent)
            Toast.makeText(
                    mActivity,
                    getString(R.string.service_start_successfully),
                    Toast.LENGTH_SHORT
            ).show()
        } else {
            Toast.makeText(
                    mActivity,
                    getString(R.string.service_already_running),
                    Toast.LENGTH_SHORT
            ).show()
        }
    }

    fun stopSharing() {
//        mLocationService = LocationService()
        mServiceIntent = Intent(this, mLocationService::class.java)
        mServiceIntent.action = "fullStop"
        if (Util.isMyServiceRunning(mLocationService::class.java, mActivity)) {
            val sharedPref = this.getSharedPreferences(getString(R.string.preference_file_key), Context.MODE_PRIVATE)
            with(sharedPref.edit()) {
                putBoolean(getString(R.string.user_stopped_service), true)
                apply()
            }

            stopService(mServiceIntent)

//            val broadcastIntent = Intent()
//            broadcastIntent.action = LocationService.USER_STOP_SERVICE_REQUEST
//            broadcastIntent.setClass(this, LocationService.UserStopServiceReceiver::class.java)
//            sendBroadcast(broadcastIntent)
        }
    }

    fun stopLocationService() {
        if (::mServiceIntent.isInitialized) {
            stopService(mServiceIntent)
        }
    }


    companion object {
        const val FINE_LOCATION_ACCESS_REQUEST_CODE = 99
        const val FINE_BACKGROUND_LOCATION_ACCESS_REQUEST_CODE = 10002
    }

}