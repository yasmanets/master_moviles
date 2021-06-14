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

class UpdateActivity : AppCompatActivity(), View.OnClickListener {

    var userName: EditText? = null
    var password: EditText? = null
    var fullName: EditText? = null
    var email: EditText? = null
    var updateUser: Button? = null
    var back: Button? = null
    private lateinit var user: Users
    private val database = Database(this)

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_update)

        this.getUserData()
        this.setUIContent(user)
    }

    private fun getUserData() {
        val userId = intent.getIntExtra("userId", -1)
        if (userId == -1) {
            Toast.makeText(this, "No existe el usuario", Toast.LENGTH_SHORT).show()
            finish()
        }
        user = database.getUser(userId)!!
    }

    private fun setUIContent(user: Users) {
        title = "Actualizar usuario"
        userName = findViewById(R.id.userNameUpdate)
        password = findViewById(R.id.passwordUpdate)
        fullName = findViewById(R.id.fullNameUpdate)
        email = findViewById(R.id.emailUpdate)
        updateUser = findViewById(R.id.updateUser)
        back = findViewById(R.id.back)

        updateUser?.setOnClickListener(this)
        back?.setOnClickListener(this)

        userName?.setText(user.nombre_usuario)
        password?.setText(user.password)
        fullName?.setText(user.nombre_completo)
        email?.setText(user.email)
    }

    override fun onClick(view: View?) {
        when (view?.id) {
            R.id.updateUser -> {
                this.updateUser()
            }
            R.id.back -> finish()
            else -> Toast.makeText(this, "No existe la opción seleccionada", Toast.LENGTH_SHORT).show()
        }
    }

    private fun updateUser(): Boolean {
        val userId = intent.getIntExtra("userId", -1)
        if (userId == -1) {
            return false
        }
        val userName = userName?.text.toString()
        val fullName = fullName?.text.toString()
        val password = password?.text.toString()
        val email = email?.text.toString()
        val database = Database(this)
        return if (userName.trim().isNotEmpty() && fullName.trim().isNotEmpty() && password.trim().isNotEmpty() && email.trim().isNotEmpty()) {
            val user = Users(id = userId, userName, password = password, nombre_completo = fullName, email = email)
            val isUpdated = database.updateUser(user)
            if (isUpdated > -1) {
                Toast.makeText(this, "Usuario actualizado con éxito", Toast.LENGTH_SHORT).show()
                true
            } else {
                Toast.makeText(this, "No se ha podido actualizar el usuario", Toast.LENGTH_SHORT).show()
                false
            }
        } else {
            Toast.makeText(this, "Debes rellenar todos los campos para poder actualizar el usuario", Toast.LENGTH_SHORT).show()
            false
        }
    }
}