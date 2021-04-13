package es.ua.eps.mm2021.kotlin.filmoteca.adapters

import android.app.Activity
import android.content.Context
import android.view.View
import android.widget.TextView
import com.google.android.gms.maps.GoogleMap
import com.google.android.gms.maps.model.Marker
import es.ua.eps.mm2021.kotlin.filmoteca.R

class MarkerAdapter(context: Context): GoogleMap.InfoWindowAdapter {
    val context = context
    private val view: View = (context as Activity).layoutInflater.inflate(R.layout.marker_view, null)
    private var title: TextView? = null
    private var content: TextView? = null

    override fun getInfoWindow(marker: Marker?): View {
        title = view?.findViewById(R.id.markerTitle)
        content = view?.findViewById(R.id.markerContent)
        title?.text = marker?.title
        content?.text = marker?.snippet!!
        return view
    }

    override fun getInfoContents(marker: Marker?): View? {
        title = view?.findViewById(R.id.markerTitle)
        content = view?.findViewById(R.id.markerContent)
        title?.text = marker?.title
        content?.text = marker?.snippet!!
        return view
    }
}