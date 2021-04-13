package es.ua.eps.mm2021.kotlin.filmoteca

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log
import android.widget.Toast
import com.google.android.gms.location.Geofence
import com.google.android.gms.location.GeofenceStatusCodes
import com.google.android.gms.location.GeofencingEvent

class GeofenceBroadcastReciver: BroadcastReceiver() {
    override fun onReceive(context: Context?, intent: Intent?) {
        val geofencingEvent = GeofencingEvent.fromIntent(intent)
        if (geofencingEvent.hasError()) {
            val errorMessage = GeofenceStatusCodes
                .getStatusCodeString(geofencingEvent.errorCode)
            Log.e("Filmoteca", errorMessage)
            return
        }

        val geofenceTransition = geofencingEvent.geofenceTransition

        if (geofenceTransition == Geofence.GEOFENCE_TRANSITION_ENTER || geofenceTransition == Geofence.GEOFENCE_TRANSITION_EXIT) {
            val triggeringGeofences = geofencingEvent.triggeringGeofences
            val geofenceTransitionDetails = getGeofenceTransitionDetails(context!!, geofenceTransition)

            Log.i("Filmoteca", "$geofenceTransitionDetails")
        } else {
            // Log the error.
            Log.e("Filmoteca", "Trnsition invalid type $geofenceTransition")
        }
    }

    private fun getGeofenceTransitionDetails(context: Context, geofenceTransition: Int) {
        when (geofenceTransition) {
            1 -> Toast.makeText(context, "Estas a 500 metros del lugar donde se rodó la película", Toast.LENGTH_LONG).show()
            2 -> Log.i("Filmoteca", "Sale del círculo")
            else -> ""
        }
    }
}