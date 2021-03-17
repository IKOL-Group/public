package org.ikol.public_app.map

import android.Manifest
import android.app.Activity
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Build
import android.os.Bundle
import android.util.Log
import android.view.View
import android.widget.Toast
import androidx.appcompat.app.AlertDialog
import androidx.appcompat.app.AppCompatActivity
import androidx.core.app.ActivityCompat
import org.ikol.public_app.LocationService
import org.ikol.public_app.LocationService.Companion.USER_STOP_SERVICE_REQUEST
import org.ikol.public_app.R
import org.ikol.public_app.databinding.ActivityMainBinding
import org.ikol.public_app.util.Util

class MapActivity : AppCompatActivity() {
    private var mLocationService: LocationService = LocationService()
    private lateinit var mServiceIntent: Intent
    private lateinit var mActivity: Activity
    private lateinit var binding: ActivityMainBinding

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityMainBinding.inflate(layoutInflater)
        val view: View = binding.root
        setContentView(view)

        mActivity = this@MapActivity

        if (!Util.isLocationEnabledOrNot(mActivity)) {
            Util.showAlertLocation(
                    mActivity,
                    getString(R.string.gps_enable),
                    getString(R.string.please_turn_on_gps),
                    getString(
                            R.string.ok
                    )
            )
        }
        checkLocationPermissions()

        binding.txtStartService.setOnClickListener {
            mLocationService = LocationService()
            mServiceIntent = Intent(this, mLocationService.javaClass)
            if (!Util.isMyServiceRunning(mLocationService.javaClass, mActivity)) {
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

        binding.txtStopService.setOnClickListener {
            mLocationService = LocationService()
            mServiceIntent = Intent(this, mLocationService::class.java)
            mServiceIntent.action = "fullStop"
            if (Util.isMyServiceRunning(mLocationService::class.java, mActivity)) {
                val sharedPref = this.getSharedPreferences(getString(R.string.preference_file_key), Context.MODE_PRIVATE)
                with(sharedPref.edit()) {
                    putBoolean(getString(R.string.user_stopped_service), true)
                    apply()
                }

                stopService(mServiceIntent)

                val broadcastIntent = Intent()
                broadcastIntent.action = USER_STOP_SERVICE_REQUEST
                broadcastIntent.setClass(this, LocationService.UserStopServiceReceiver::class.java)
                sendBroadcast(broadcastIntent)
            }
        }
    }


//    https://github.com/IKOL-Group/public/blob/d77cb83805db901a952b9caf9a1d2670301a6520/android/app/src/main/kotlin/org/ikol/public_app/map/MapActivity.kt#L79
    private fun checkLocationPermissions() {
        if (ActivityCompat.checkSelfPermission(
                        this,
                        Manifest.permission.ACCESS_FINE_LOCATION
                ) != PackageManager.PERMISSION_GRANTED
        ) {
            // Should we show an explanation?
//            if (ActivityCompat.shouldShowRequestPermissionRationale(
//                            this,
//                            Manifest.permission.ACCESS_FINE_LOCATION
//                    )
//            ) {
            // Show an explanation to the user *asynchronously* -- don't block
            // this thread waiting for the user's response! After the user
            // sees the explanation, try again to request the permission.
            AlertDialog.Builder(this)
                    .setTitle("Location Permission Needed")
                    .setMessage("This app needs the Location permission, please accept to use location functionality")
                    .setPositiveButton(
                            "OK"
                    ) { _, _ ->
                        Log.d("TAG", Build.VERSION.SDK_INT.toString())
                        //Prompt the user once explanation has been shown
                        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                            ActivityCompat.requestPermissions(
                                    this@MapActivity,
                                    arrayOf(
                                            Manifest.permission.ACCESS_FINE_LOCATION,
                                            Manifest.permission.ACCESS_BACKGROUND_LOCATION,
                                    ),
                                    FINE_BACKGROUND_LOCATION_ACCESS_REQUEST_CODE
                            )
                        } else {
                            ActivityCompat.requestPermissions(
                                    this@MapActivity,
                                    arrayOf(Manifest.permission.ACCESS_FINE_LOCATION),
                                    FINE_LOCATION_ACCESS_REQUEST_CODE
                            )
                        }
                    }
                    .create()
                    .show()
//            } else {
//                // No explanation needed, we can request the permission.
//                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
//                    ActivityCompat.requestPermissions(
//                            this@MapActivity,
//                            arrayOf(Manifest.permission.ACCESS_FINE_LOCATION, Manifest.permission.ACCESS_BACKGROUND_LOCATION),
//                            FINE_BACKGROUND_LOCATION_ACCESS_REQUEST_CODE
//                    )
//                } else {
//                    ActivityCompat.requestPermissions(
//                            this@MapActivity,
//                            arrayOf(Manifest.permission.ACCESS_FINE_LOCATION),
//                            FINE_LOCATION_ACCESS_REQUEST_CODE
//                    )
//                }
//            }
        }
    }

    override fun onRequestPermissionsResult(
            requestCode: Int,
            permissions: Array<String>, grantResults: IntArray
    ) {
        when (requestCode) {
            FINE_LOCATION_ACCESS_REQUEST_CODE, FINE_BACKGROUND_LOCATION_ACCESS_REQUEST_CODE -> {
                // If request is cancelled, the result arrays are empty.
                if (grantResults.isNotEmpty() && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                    // Got permission
                } else {
                    // permission denied, boo! Disable the
                    // functionality that depends on this permission.
                    Toast.makeText(this, "permission denied", Toast.LENGTH_LONG).show()
                }
                return
            }
        }// other 'case' lines to check for other
        // permissions this app might request
    }

    companion object {
        private const val FINE_LOCATION_ACCESS_REQUEST_CODE = 99
        private const val FINE_BACKGROUND_LOCATION_ACCESS_REQUEST_CODE = 10002
    }

    override fun onDestroy() {
        if (::mServiceIntent.isInitialized) {
            stopService(mServiceIntent)
        }
        super.onDestroy()
    }

}
