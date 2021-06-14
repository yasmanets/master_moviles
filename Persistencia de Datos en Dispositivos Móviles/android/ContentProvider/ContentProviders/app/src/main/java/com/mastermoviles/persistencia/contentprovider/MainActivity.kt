package com.mastermoviles.persistencia.contentprovider

import android.content.Intent
import android.net.Uri
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.util.Log
import android.widget.Button
import android.widget.EditText
import android.widget.Toast

class MainActivity : AppCompatActivity() {

    var userName: EditText? = null
    var password: EditText? = null
    var login: Button? = null
    var close: Button? = null
    var CONTENT_URI = Uri.parse("content://com.mastermoviles.persistencia.sqlite.Provider.UsersProvider/Usuarios")

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        this.setUIContent()
    }

    private fun setUIContent() {
        userName = findViewById(R.id.userName)
        password = findViewById(R.id.password)
        login = findViewById(R.id.login)
        close = findViewById(R.id.close)

        login?.setOnClickListener{
            this.login()
        }

        close?.setOnClickListener{
            finish()
        }
    }

    private fun login(): Boolean {
        val name = userName?.text.toString()
        val pass = password?.text.toString()
        if (name.isEmpty() || pass.isEmpty()) {
            Toast.makeText(this,"Debes introducir el nombre de usuario y la contraseña", Toast.LENGTH_SHORT).show()
            return false
        }
        val where = "nombre_usuario='$name'"
        val cursor = contentResolver.query(CONTENT_URI, null, where, null, null)

        if (cursor!!.moveToFirst()) {
            val password = cursor.getString(cursor.getColumnIndex("password"))
            if (pass != password) {
                Toast.makeText(this, "La contraseña introducida no es correcta", Toast.LENGTH_SHORT).show()
                return false
            }
            val userName = cursor.getString(cursor.getColumnIndex("nombre_usuario"))
            val fullName = cursor.getString(cursor.getColumnIndex("nombre_completo"))
            val intent = Intent(this, UserActivity::class.java)
            intent.putExtra("userName", userName)
            intent.putExtra("fullName", fullName)
            startActivity(intent)
            return true
        }
        else {
            Toast.makeText(this, "No existe ningún usuario con ese nombre", Toast.LENGTH_SHORT).show()
            return false
        }
    }
}