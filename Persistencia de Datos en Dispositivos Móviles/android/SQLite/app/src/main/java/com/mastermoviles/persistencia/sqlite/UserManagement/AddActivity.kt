package com.mastermoviles.persistencia.sqlite.UserManagement

import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.view.View
import android.widget.Button
import android.widget.EditText
import android.widget.Toast
import com.mastermoviles.persistencia.sqlite.Data.Database
import com.mastermoviles.persistencia.sqlite.Models.Users
import com.mastermoviles.persistencia.sqlite.R

class AddActivity : AppCompatActivity(), View.OnClickListener {

    var userName: EditText? = null
    var password: EditText? = null
    var fullName: EditText? = null
    var email: EditText? = null
    var addUser: Button? = null
    var back: Button? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_add)

        this.setUIContent()
    }

    private fun setUIContent() {
        title = "Nuevo usuario"
        userName = findViewById(R.id.userNameEdit)
        password = findViewById(R.id.passwordEdit)
        fullName = findViewById(R.id.fullNameEdit)
        email = findViewById(R.id.emailEdit)
        addUser = findViewById(R.id.addUser)
        back = findViewById(R.id.back)

        addUser?.setOnClickListener(this)
        back?.setOnClickListener(this)
    }

    override fun onClick(view: View?) {
        when (view?.id) {
            R.id.addUser -> {
                this.addUser()
                this.cleanFields()
            }
            R.id.back -> finish()
            else -> Toast.makeText(this, "No existe la opción seleccionada", Toast.LENGTH_SHORT).show()
        }
    }

    private fun addUser(): Boolean {
        val userName = userName?.text.toString()
        val fullName = fullName?.text.toString()
        val password = password?.text.toString()
        val email = email?.text.toString()
        val database = Database(this)
        return if (userName.trim().isNotEmpty() && fullName.trim().isNotEmpty() && password.trim().isNotEmpty() && email.trim().isNotEmpty()) {
            val user = Users(id = null, userName, password = password, nombre_completo = fullName, email = email)
            val isAdded = database.addUser(user)
            if (isAdded > -1) {
                Toast.makeText(this, "Usuario guardado con éxito", Toast.LENGTH_SHORT).show()
                true
            } else {
                Toast.makeText(this, "No se ha podido guardar el usuario", Toast.LENGTH_SHORT).show()
                false
            }
        } else {
            Toast.makeText(this, "Debes rellenar todos los campos para poder guardar el usuario", Toast.LENGTH_SHORT).show()
            false
        }
    }

    private fun cleanFields() {
        userName?.text?.clear()
        fullName?.text?.clear()
        password?.text?.clear()
        email?.text?.clear()
    }
}