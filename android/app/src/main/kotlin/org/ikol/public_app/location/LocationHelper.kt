package org.ikol.public_app.location

import android.Manifest
import android.app.Activity
import android.content.Context
import android.content.ContextWrapper
import android.content.Intent
import android.content.LocusId
import android.content.pm.PackageManager
import android.os.Build
import androidx.core.app.ActivityCompat
import org.ikol.public_app.LocationService
import org.ikol.public_app.R
import org.ikol.public_app.util.Util


class LocationHelper(private var mActivity: Activity, base: Context) : ContextWrapper(base) {
    private var mLocationService: LocationService = LocationService()
    private lateinit var mServiceIntent: Intent
    private lateinit var id: String

    fun isLocationEnabled(): Boolean {
        return Util.isLocationEnabledOrNot(mActivity)
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
            if (Build.VERSION.SDK_INT > Build.VERSION_CODES.Q) {
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

    fun startSharing(userId: String) {
        id = userId
        mServiceIntent = Intent(this, mLocationService::class.java)
        mServiceIntent.putExtra("id",userId);
        if (!Util.isMyServiceRunning(mLocationService::class.java, mActivity)) {
            startService(mServiceIntent)
        }
    }

    fun stopSharing() {
        mServiceIntent = Intent(this, mLocationService::class.java)
        mServiceIntent.action = "fullStop"
        if (Util.isMyServiceRunning(mLocationService::class.java, mActivity)) {
            val sharedPref = this.getSharedPreferences(getString(R.string.preference_file_key), Context.MODE_PRIVATE)
            with(sharedPref.edit()) {
                putBoolean(getString(R.string.user_stopped_service), true)
                apply()
            }

            stopLocationService()
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