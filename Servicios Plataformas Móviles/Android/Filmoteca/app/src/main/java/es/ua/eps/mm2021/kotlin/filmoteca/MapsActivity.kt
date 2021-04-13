package es.ua.eps.mm2021.kotlin.filmoteca

import android.Manifest
import android.app.PendingIntent
import android.content.Intent
import android.content.IntentSender
import android.content.pm.PackageManager
import android.graphics.Color
import android.location.Location
import android.location.LocationManager
import android.location.LocationProvider
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.os.Looper
import android.provider.SyncStateContract
import android.util.Log
import androidx.core.app.ActivityCompat
import com.google.android.gms.common.api.ResolvableApiException
import com.google.android.gms.location.*
import com.google.android.gms.maps.*
import com.google.android.gms.maps.model.CircleOptions
import com.google.android.gms.maps.model.LatLng
import com.google.android.gms.maps.model.MarkerOptions
import es.ua.eps.mm2021.kotlin.filmoteca.adapters.MarkerAdapter

class MapsActivity : AppCompatActivity(), OnMapReadyCallback {

    private lateinit var mMap: GoogleMap
    private var title: String? = null
    private var director: String? = null
    private var year: Int? = null
    private var latitude: Double? = null
    private var longitude: Double? = null

    private lateinit var mFusedLocation: FusedLocationProviderClient
    private lateinit var locationRequest: LocationRequest
    private lateinit var locationCallback: LocationCallback
    private lateinit var currentLocation: Location
    private lateinit var geofencingClient: GeofencingClient
    private var GEOFENCE_RADIOUS = 500

    private val geofencePendingIntent: PendingIntent by lazy {
        val intent = Intent(this, GeofenceBroadcastReciver::class.java)
        PendingIntent.getBroadcast(this, 0, intent, PendingIntent.FLAG_UPDATE_CURRENT)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_maps)

        val mapFragment = supportFragmentManager.findFragmentById(R.id.map) as SupportMapFragment
        mapFragment.getMapAsync(this)

        geofencingClient = LocationServices.getGeofencingClient(this)

        locationCallback = object: LocationCallback() {
            override fun onLocationResult(locationResult: LocationResult) {
                super.onLocationResult(locationResult)
                if (locationResult === null) return
                currentLocation = locationResult.lastLocation
            }
        }
    }

    override fun onMapReady(googleMap: GoogleMap) {
        if (ActivityCompat.checkSelfPermission(this, Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED &&
            ActivityCompat.checkSelfPermission(this, Manifest.permission.ACCESS_COARSE_LOCATION) != PackageManager.PERMISSION_GRANTED)
        {
            ActivityCompat.requestPermissions(this, arrayOf(Manifest.permission.ACCESS_FINE_LOCATION), 101)
            return
        }

        getIntentValues(intent)
        mMap = googleMap
        val position = LatLng(latitude!!, longitude!!)
        val center: CameraUpdate = CameraUpdateFactory.newLatLng(position)
        val zoom: CameraUpdate = CameraUpdateFactory.zoomTo(15.0F)

        mMap.addMarker(MarkerOptions().position(position)
            .title(title)
            .snippet("Director: $director\nAño de estreno: $year"))
        mMap.moveCamera(center)
        mMap.animateCamera(zoom)
        mMap.uiSettings.isMapToolbarEnabled = true
        mMap.uiSettings.isZoomControlsEnabled = true
        mMap.setInfoWindowAdapter(MarkerAdapter(this))
        mMap.isMyLocationEnabled = true
        mMap.addCircle(CircleOptions()
            .center(position)
            .radius(GEOFENCE_RADIOUS.toDouble())
            .strokeColor(Color.argb(64,255, 0, 0))
            .fillColor(Color.argb(64,255, 0, 0))
        )

        /* ------------- */

        mFusedLocation = LocationServices.getFusedLocationProviderClient(this)
        mFusedLocation.lastLocation.addOnSuccessListener {
            createLocationRequest()
            val builder = LocationSettingsRequest.Builder().addLocationRequest(locationRequest)
            val client = LocationServices.getSettingsClient(this)
            val task = client.checkLocationSettings(builder.build())
            task.addOnSuccessListener { response ->
                val states = response.locationSettingsStates
                if (states.isLocationPresent) {
                    mFusedLocation.requestLocationUpdates(locationRequest, locationCallback, Looper.getMainLooper())
                }
            }
                .addOnFailureListener { ex ->
                    Log.e("Filmoteca", "onFailure()", ex)
                    if (ex is ResolvableApiException) {
                        // User dialog
                        try {
                            ex.startResolutionForResult(this, 999)
                        }
                        catch (senEx: IntentSender.SendIntentException) {
                            // ignorar el error
                        }
                    }
                }
        }

        val geofence: Geofence = Geofence.Builder().setRequestId(title)
            .setCircularRegion(latitude!!, longitude!!, GEOFENCE_RADIOUS.toFloat())
            .setExpirationDuration(Geofence.NEVER_EXPIRE)
            .setTransitionTypes(Geofence.GEOFENCE_TRANSITION_ENTER or Geofence.GEOFENCE_TRANSITION_EXIT)
            .build()
        geofencingClient.addGeofences(getGeofencingRequest(geofence), geofencePendingIntent)?.run {
            addOnSuccessListener {
                //geo added
            }
            addOnFailureListener {
                // failed
            }
        }
    }

    private fun getIntentValues(intent: Intent) {
        title = intent.getStringExtra("title")
        director = intent.getStringExtra("director")
        year = intent.getIntExtra("year", 0)
        latitude = intent.getDoubleExtra("latitude", 0.0)
        longitude = intent.getDoubleExtra("longitude", 0.0)
    }

    private fun createLocationRequest() {
        locationRequest = LocationRequest.create()
        locationRequest.interval = 10000
        locationRequest.fastestInterval = 5000
        locationRequest.priority = LocationRequest.PRIORITY_HIGH_ACCURACY
    }

    /*override fun onPause() {
        super.onPause()
        mFusedLocation.removeLocationUpdates(locationCallback)
    }*/

    private fun getGeofencingRequest(geofence: Geofence): GeofencingRequest {
        return GeofencingRequest.Builder().apply {
            setInitialTrigger(GeofencingRequest.INITIAL_TRIGGER_ENTER)
            addGeofence(geofence)
        }.build()
    }
}