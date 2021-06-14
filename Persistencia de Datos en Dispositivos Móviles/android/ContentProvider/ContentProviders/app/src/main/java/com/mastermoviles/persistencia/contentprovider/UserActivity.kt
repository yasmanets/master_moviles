package com.mastermoviles.persistencia.contentprovider

import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.widget.Button
import android.widget.TextView

class UserActivity : AppCompatActivity() {

    var userName: TextView? = null
    var fullName: TextView? = null
    var back: Button? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_user)

        this.setUIContent()
    }

    private fun setUIContent() {
        title = "Usuario"
        userName = findViewById(R.id.userNameData)
        fullName = findViewById(R.id.fullNameData)
        back = findViewById(R.id.back)

        back?.setOnClickListener { finish() }

        val intent = intent
        val name = intent.getStringExtra("userName")
        val full = intent.getStringExtra("fullName")
        fullName?.text = "Bienvenido:\t $full"
        userName?.text = "User Name:\t $name"
    }
}