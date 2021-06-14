package com.mastermovilesua.persistencia.sharedpreferences2.Fragments

import android.os.Bundle
import androidx.preference.PreferenceFragmentCompat
import com.mastermovilesua.persistencia.sharedpreferences2.R

class SettingsFragment : PreferenceFragmentCompat() {

    override fun onCreatePreferences(savedInstanceState: Bundle?, rootKey: String?) {
        setPreferencesFromResource(R.xml.preferences, rootKey)

    }
}