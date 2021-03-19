package org.ikol.public_app

import android.content.pm.PackageManager
import android.widget.Toast
import androidx.annotation.NonNull
import io.flutter.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import org.ikol.public_app.location.LocationHelper

class MainActivity : FlutterActivity() {
    private lateinit var mLocationHelper: LocationHelper

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        mLocationHelper = LocationHelper(activity, applicationContext)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "shouldShowRequestPermissionRationale" -> {
                    result.success(mLocationHelper.shouldShowRequestPermissionRationale())
                }
                "checkLocationPermissions" -> {
                    if (mLocationHelper.isLocationEnabled()) {
                        mLocationHelper.checkLocationPermissions()
                        result.success(null)
                        return@setMethodCallHandler
                    }
                    result.error("LOCATION_OFF", "Location needs to be turned on", null)
                }
                "isLocationEnabled" -> {
                    result.success(mLocationHelper.isLocationEnabled())
                }
                "startSharing" -> {
                    mLocationHelper.startSharing()
                }
                "stopSharing" -> {
                    mLocationHelper.stopSharing()
                }
                else -> {
                    result.error("NOT_FOUND", "no such method", call.method)
                }
            }
        }
    }

    override fun onRequestPermissionsResult(
            requestCode: Int,
            permissions: Array<String>, grantResults: IntArray
    ) {
        when (requestCode) {
            LocationHelper.FINE_LOCATION_ACCESS_REQUEST_CODE,
            LocationHelper.FINE_BACKGROUND_LOCATION_ACCESS_REQUEST_CODE -> {
                // If request is cancelled, the result arrays are empty.
                if (grantResults.isNotEmpty()) return
                if (grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                    // Got permission
                } else {
                    // TODO check if we got background location permission if >= android 11
                    // permission denied, boo! Disable the
                    // functionality that depends on this permission.
                    Toast
                            .makeText(this, "Location permission is required", Toast.LENGTH_LONG)
                            .show()
                    Log.d("Denied?", (grantResults[0] == PackageManager.PERMISSION_DENIED).toString())
                    if (grantResults[0] == PackageManager.PERMISSION_DENIED) {
//                        TODO open settings
                        Toast
                                .makeText(this, "Permanently denying will not help YOU!!!!", Toast.LENGTH_LONG)
                                .show()
                    } else {
                        mLocationHelper.checkLocationPermissions()
                    }
                }
                return
            }
        }// other 'case' lines to check for other
        // permissions this app might request
    }

    override fun onDestroy() {
        mLocationHelper.stopLocationService()
        super.onDestroy()
    }


    companion object {
        private const val CHANNEL = "org.ikol.public_app/share"
    }

}
