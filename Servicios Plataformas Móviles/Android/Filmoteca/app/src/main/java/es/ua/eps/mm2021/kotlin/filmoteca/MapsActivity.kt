package es.ua.eps.mm2021.kotlin.filmoteca

import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.util.Log
import com.google.android.gms.maps.CameraUpdateFactory
import com.google.android.gms.maps.GoogleMap
import com.google.android.gms.maps.OnMapReadyCallback
import com.google.android.gms.maps.SupportMapFragment
import com.google.android.gms.maps.model.LatLng
import com.google.android.gms.maps.model.MarkerOptions

class MapsActivity : AppCompatActivity(), OnMapReadyCallback {

    private lateinit var mMap: GoogleMap

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_maps)

        val mapFragment = supportFragmentManager.findFragmentById(R.id.map) as SupportMapFragment
        mapFragment.getMapAsync(this)
        Log.d("Maps", "${intent.getStringExtra("title")}")
    }

    override fun onMapReady(googleMap: GoogleMap) {
        mMap = googleMap
        val position = LatLng(0.0, 0.0)
        mMap.addMarker(MarkerOptions().position(position).title("Se ha grabado aquí"))
        mMap.moveCamera(CameraUpdateFactory.newLatLng(position))
    }
}