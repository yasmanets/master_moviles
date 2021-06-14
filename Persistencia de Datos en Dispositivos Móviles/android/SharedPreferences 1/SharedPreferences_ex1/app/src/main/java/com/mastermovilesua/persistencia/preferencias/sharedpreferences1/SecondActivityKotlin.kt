package com.mastermovilesua.persistencia.preferencias.sharedpreferences1

import android.app.Activity
import android.content.Context
import android.content.SharedPreferences
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.view.Gravity
import android.widget.Button
import android.widget.TextView
import com.mastermovilesua.persistencia.preferencias.sharedpreferences1.Base64Kotlin.Base64Cipher

class SecondActivityKotlin : AppCompatActivity() {

    private var textView: TextView? = null
    private var backButton: Button? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_second)
        val preferences: SharedPreferences = getSharedPreferences("preferences", Context.MODE_PRIVATE)
        this.title = "SharedPreferences_ex1 Detail (Kotlin)"

        this.setUIContent()
        this.getPreferencesData(preferences)

        this.backButton?.setOnClickListener {
            setResult(Activity.RESULT_OK)
            finish()
        }
    }

    private fun setUIContent() {
        this.textView = findViewById(R.id.secondViewTextView)
        this.backButton = findViewById(R.id.buttonBack)
    }

    private fun getPreferencesData(preferences: SharedPreferences) {
        val text = preferences.getString("text", "Hola Mundo!").toString()
        val size = preferences.getString("size", "32").toString()
        this.textView?.text = Base64Cipher.decryptData(text)
        this.textView?.textSize = Base64Cipher.decryptData(size).toFloat()
        this.textView?.gravity = Gravity.CENTER_HORIZONTAL
    }
}