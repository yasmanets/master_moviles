package com.mastermovilesua.persistencia.preferencias.sharedpreferences1

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.widget.Button
import android.widget.EditText
import android.widget.SeekBar
import android.widget.TextView
import com.mastermovilesua.persistencia.preferencias.sharedpreferences1.Base64Kotlin.Base64Cipher

private const val ACTIVITY_RESULT_CODE = 1

class MainActivity : AppCompatActivity(), SeekBar.OnSeekBarChangeListener {

    private var editText: EditText? =null
    private var seekBarText: TextView? = null
    private var seekBar: SeekBar? = null
    private var applyChanges: Button? = null
    private var resultsText: TextView? = null
    private var javaButton: Button? = null
    private var closeButton: Button? = null
    private lateinit var preferences: SharedPreferences

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
        preferences = getSharedPreferences("preferences", Context.MODE_PRIVATE)
        this.title = "SharedPreferences_ex1 (Kotlin)"


        this.setUIContent()
        this.seekBar?.setOnSeekBarChangeListener(this)
        this.applyChanges?.setOnClickListener {
            this.setPreferencesData(preferences)
            val intent = Intent(this, SecondActivityKotlin::class.java)
            startActivityForResult(intent, ACTIVITY_RESULT_CODE)
        }
        this.javaButton?.setOnClickListener {
            val intent = Intent(this, MainActivityJava::class.java)
            startActivity(intent)
        }

        this.closeButton?.setOnClickListener {
            finish()
        }
    }

    private fun setUIContent() {
        this.editText = findViewById(R.id.editText)
        this.seekBarText = findViewById(R.id.seekSize)
        this.seekBar = findViewById(R.id.seekBar)
        this.applyChanges = findViewById(R.id.applyChanges)
        this.resultsText = findViewById(R.id.results)
        this.javaButton = findViewById(R.id.changeVersion)
        this.javaButton?.setBackgroundResource(R.drawable.java);
        this.closeButton = findViewById(R.id.close)
    }

    private fun setPreferencesData(preferences: SharedPreferences) {
        val encryptedText = Base64Cipher.encryptData(this.editText?.text.toString())
        val encryptedSize = Base64Cipher.encryptData(this.seekBar?.progress!!.toString())
        val editor = preferences.edit()
        editor.putString("text", encryptedText)
        editor.putString("size", encryptedSize)
        editor.apply()
    }

    override fun onProgressChanged(seekBar: SeekBar?, progress: Int, fromUser: Boolean) {
        this.seekBarText?.text = "Tamaño (${progress.toString()}/50)"
    }

    override fun onStartTrackingTouch(seekBar: SeekBar?) {

    }

    override fun onStopTrackingTouch(seekBar: SeekBar?) {

    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == ACTIVITY_RESULT_CODE && resultCode == Activity.RESULT_OK) {
            val text = preferences.getString("text", "Hola Mundo!").toString()
            val size = preferences.getString("size", "32").toString()
            this.resultsText?.setText("Valores actuales de la aplicación:\n\n" +
                    "Texto: ${Base64Cipher.decryptData(text)}\n" +
                    "Tamaño: ${Base64Cipher.decryptData(size)}")
        }

    }
}