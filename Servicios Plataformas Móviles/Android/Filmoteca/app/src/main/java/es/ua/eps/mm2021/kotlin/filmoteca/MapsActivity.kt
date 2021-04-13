package es.ua.eps.mm2021.kotlin.filmoteca

import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.util.Log
import com.google.android.gms.maps.*
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

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_maps)

        val mapFragment = supportFragmentManager.findFragmentById(R.id.map) as SupportMapFragment
        mapFragment.getMapAsync(this)
    }

    override fun onMapReady(googleMap: GoogleMap) {
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
    }

    private fun getIntentValues(intent: Intent) {
        title = intent.getStringExtra("title")
        director = intent.getStringExtra("director")
        year = intent.getIntExtra("year", 0)
        latitude = intent.getDoubleExtra("latitude", 0.0)
        longitude = intent.getDoubleExtra("longitude", 0.0)
    }
}