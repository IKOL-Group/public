package org.ikol.public_app.map

import android.Manifest
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Build
import android.os.Bundle
import android.util.Log
import android.widget.Toast
import androidx.appcompat.app.AlertDialog
import androidx.appcompat.app.AppCompatActivity
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import com.google.android.gms.location.*
import org.ikol.public_app.LocationUpdateService
import org.ikol.public_app.R


class MapsActivity : AppCompatActivity() {

    private lateinit var mLocationRequest: LocationRequest
    private var mFusedLocationClient: FusedLocationProviderClient? = null
    private var mpendingIntent: PendingIntent? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_maps)

        supportActionBar?.hide()

        mFusedLocationClient = LocationServices.getFusedLocationProviderClient(this)
        setupLocation()
//        startForegroundService(mpendingIntent)
    }

//    public override fun onPause() {
//        super.onPause()
//
//        //stop location updates when Activity is no longer active
//        mFusedLocationClient?.removeLocationUpdates(mLocationCallback)
//    }

    private fun setupLocation() {
        mLocationRequest = LocationRequest.create()
        mLocationRequest.interval = 3 * 1000 // two minute interval
        mLocationRequest.fastestInterval = 2 * 1000
        mLocationRequest.priority = LocationRequest.PRIORITY_HIGH_ACCURACY

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            if (ContextCompat.checkSelfPermission(
                            this,
                            Manifest.permission.ACCESS_FINE_LOCATION
                    ) == PackageManager.PERMISSION_GRANTED
            ) {
                //Location Permission already granted
                mFusedLocationClient?.requestLocationUpdates(mLocationRequest, createLocationServiceIntent(this))
            } else {
                //Request Location Permission
                checkLocationPermission()
            }
        } else {
            mFusedLocationClient?.requestLocationUpdates(mLocationRequest, createLocationServiceIntent(this))
        }
    }

    private fun createLocationServiceIntent(context: Context): PendingIntent {
        if (mpendingIntent != null) {
            return mpendingIntent!!
        }
        val intent = Intent(context, LocationUpdateService::class.java)
        intent.action = LocationUpdateService.ACTION_HANDLE_LOCATION
        mpendingIntent = PendingIntent.getService(context, 1, intent, PendingIntent.FLAG_UPDATE_CURRENT)
        return mpendingIntent!!
    }


    private fun checkLocationPermission() {
        if (ActivityCompat.checkSelfPermission(
                        this,
                        Manifest.permission.ACCESS_FINE_LOCATION
                ) != PackageManager.PERMISSION_GRANTED
        ) {
            // Should we show an explanation?
            if (ActivityCompat.shouldShowRequestPermissionRationale(
                            this,
                            Manifest.permission.ACCESS_FINE_LOCATION
                    )
            ) {
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
                                        this@MapsActivity,
                                        arrayOf(Manifest.permission.ACCESS_FINE_LOCATION, Manifest.permission.ACCESS_BACKGROUND_LOCATION),
                                        FINE_BACKGROUND_LOCATION_ACCESS_REQUEST_CODE
                                )
                            } else {
                                ActivityCompat.requestPermissions(
                                        this@MapsActivity,
                                        arrayOf(Manifest.permission.ACCESS_FINE_LOCATION),
                                        FINE_LOCATION_ACCESS_REQUEST_CODE
                                )
                            }
                        }
                        .create()
                        .show()
            } else {
                // No explanation needed, we can request the permission.
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                    ActivityCompat.requestPermissions(
                            this@MapsActivity,
                            arrayOf(Manifest.permission.ACCESS_FINE_LOCATION, Manifest.permission.ACCESS_BACKGROUND_LOCATION),
                            FINE_BACKGROUND_LOCATION_ACCESS_REQUEST_CODE
                    )
                } else {
                    ActivityCompat.requestPermissions(
                            this@MapsActivity,
                            arrayOf(Manifest.permission.ACCESS_FINE_LOCATION),
                            FINE_LOCATION_ACCESS_REQUEST_CODE
                    )
                }
            }
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

                    // permission was granted, yay! Do the
                    // location-related task you need to do.
                    if (ContextCompat.checkSelfPermission(
                                    this,
                                    Manifest.permission.ACCESS_FINE_LOCATION
                            ) == PackageManager.PERMISSION_GRANTED
                    ) {
                        mFusedLocationClient?.requestLocationUpdates(mLocationRequest, createLocationServiceIntent(this))
                    }

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
}
