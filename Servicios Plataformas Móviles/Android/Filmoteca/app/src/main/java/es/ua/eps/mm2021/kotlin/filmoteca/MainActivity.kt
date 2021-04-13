package es.ua.eps.mm2021.kotlin.filmoteca

import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.util.Log
import android.view.View
import es.ua.eps.mm2021.kotlin.filmoteca.FilmListFragment
import es.ua.eps.mm2021.kotlin.filmoteca.R

class MainActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
        if (findViewById<View?>(R.id.fragment_container) != null) {
            if (savedInstanceState != null) return
            val filmListFragment = FilmListFragment()
            filmListFragment.arguments = intent.extras
            supportFragmentManager.beginTransaction()
                .add(R.id.fragment_container, filmListFragment).commit()
        }
    }
}