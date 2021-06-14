package com.mastermovilesua.persistencia.sharedpreferences2

import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.view.MenuItem
import androidx.appcompat.app.ActionBarDrawerToggle
import androidx.core.view.GravityCompat
import androidx.drawerlayout.widget.DrawerLayout
import androidx.fragment.app.FragmentTransaction
import com.google.android.material.navigation.NavigationView
import com.mastermovilesua.persistencia.sharedpreferences2.Fragments.MainFragment
import com.mastermovilesua.persistencia.sharedpreferences2.Fragments.SettingsFragment

class MainActivity : AppCompatActivity(), NavigationView.OnNavigationItemSelectedListener {

    lateinit var mainFragment: MainFragment
    lateinit var settingsFragment: SettingsFragment
    private var drawerLayout: DrawerLayout? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        this.setNavigationViewAndToolbar()

    }

    private fun setNavigationViewAndToolbar() {
        drawerLayout = findViewById(R.id.drawerLayout)
        val navigationView: NavigationView = findViewById(R.id.navigation_view)

        setSupportActionBar(findViewById(R.id.toolbar))
        val actionBar = supportActionBar
        actionBar?.title = "Inicio"

        val drawerToggle: ActionBarDrawerToggle = object : ActionBarDrawerToggle (this, drawerLayout, findViewById(R.id.toolbar), R.string.open, R.string.close) {

        }

        drawerToggle.isDrawerIndicatorEnabled = true
        drawerLayout?.addDrawerListener(drawerToggle)
        drawerToggle.syncState()

        navigationView.setNavigationItemSelectedListener(this)
        mainFragment = MainFragment()
        supportFragmentManager.beginTransaction()
                .replace(R.id.frame_layout, mainFragment)
                .setTransition(FragmentTransaction.TRANSIT_FRAGMENT_OPEN)
                .commit()
    }

    override fun onNavigationItemSelected(item: MenuItem): Boolean {
        when (item.itemId) {
            R.id.home -> {
                mainFragment = MainFragment()
                supportFragmentManager.beginTransaction()
                    .replace(R.id.frame_layout, mainFragment)
                    .setTransition(FragmentTransaction.TRANSIT_FRAGMENT_OPEN)
                    .commit()
                supportActionBar?.title = "Inicio"
            }
            R.id.settings -> {
                settingsFragment = SettingsFragment()
                supportFragmentManager.beginTransaction()
                    .replace(R.id.frame_layout, settingsFragment)
                    .setTransition(FragmentTransaction.TRANSIT_FRAGMENT_OPEN)
                    .commit()
                supportActionBar?.title = "Ajustes"
            }
        }
        drawerLayout?.closeDrawer(GravityCompat.START, true)
        return true
    }

    override fun onBackPressed() {
        if (drawerLayout?.isDrawerOpen(GravityCompat.START) == true) {
            drawerLayout?.closeDrawer(GravityCompat.START, true)
        }
        else {
            super.onBackPressed()
        }
    }
}