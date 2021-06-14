package com.mastermoviles.persistencia.sqlite.UserManagement

import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.util.Log
import android.view.View
import android.widget.ArrayAdapter
import android.widget.Button
import android.widget.Spinner
import android.widget.Toast
import androidx.appcompat.app.AlertDialog
import com.mastermoviles.persistencia.sqlite.Data.Database
import com.mastermoviles.persistencia.sqlite.Models.Users
import com.mastermoviles.persistencia.sqlite.R

class ManagementActivity : AppCompatActivity(), View.OnClickListener {

    var newUser: Button? = null
    var updateUser: Button? = null
    var deleteUser: Button? = null
    var listUsers: Button? = null
    var back: Button? = null
    var spinner: Spinner? = null
    private var usersList: List<Users> = ArrayList()
    private val database = Database(this)

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_management)

        this.setUIContent()
    }

    override fun onRestart() {
        super.onRestart()
        this.feedSpinner()
    }

    private fun setUIContent() {
        title = "Gestión de usuarios"
        newUser = findViewById(R.id.newUser)
        updateUser = findViewById(R.id.updateUser)
        deleteUser = findViewById(R.id.deleteUser)
        listUsers = findViewById(R.id.listUsers)
        back = findViewById(R.id.back)
        spinner = findViewById(R.id.spinner)

        newUser?.setOnClickListener(this)
        updateUser?.setOnClickListener(this)
        deleteUser?.setOnClickListener(this)
        listUsers?.setOnClickListener(this)
        back?.setOnClickListener(this)

        this.feedSpinner()
    }

    private fun feedSpinner() {
        usersList = database.getUsers()
        val usersName: ArrayList<String> = ArrayList()
        usersList.forEach{ u -> usersName.add(u.nombre_usuario)}
        val adapter = ArrayAdapter(this, android.R.layout.simple_spinner_dropdown_item, usersName)
        spinner?.adapter = adapter
    }

    override fun onClick(view: View?) {
        var intent: Intent
        when (view?.id) {
            R.id.newUser -> {
                intent = Intent(this, AddActivity::class.java)
                startActivity(intent)
            }
            R.id.updateUser -> {
                if (usersList.isEmpty()) {
                    Toast.makeText(this, "Debes crear al menos un usuario, actualmente no hay usuarios registrado", Toast.LENGTH_SHORT).show()
                    return
                }
                val user = usersList[spinner?.selectedItemPosition!!]
                intent = Intent(this, UpdateActivity::class.java)
                intent.putExtra("userId", user.id)
                startActivity(intent)
            }
            R.id.deleteUser -> {
                if (usersList.isEmpty()) {
                    Toast.makeText(this, "Debes crear al menos un usuario, actualmente no hay usuarios registrado", Toast.LENGTH_SHORT).show()
                    return
                }
                this.removalDialog()
            }
            R.id.listUsers -> {
                if (usersList.isEmpty()) {
                    Toast.makeText(this, "Debes crear al menos un usuario, actualmente no hay usuarios registrado", Toast.LENGTH_SHORT).show()
                    return
                }
                intent = Intent(this, ListActivity::class.java)
                startActivity(intent)
            }
            R.id.back -> finish()
            else -> Toast.makeText(this, "No existe la opción seleccionada", Toast.LENGTH_SHORT).show()
        }
    }

    private fun removalDialog() {
        val user = usersList[spinner?.selectedItemPosition!!]
        val builder = AlertDialog.Builder(this)
        builder.setTitle("Elimnar usuario")
        builder.setMessage("¿Seguro que quieres eliminar el usuario?")
        builder.setNegativeButton("No") { dialog, _ ->
            dialog.dismiss()
        }
        builder.setPositiveButton("Sí") { dialog, _ ->
            val isRemoved = database.deleteUser(user)
            if (isRemoved > -1) {
                Toast.makeText(this, "Usuario eliminado con éxito", Toast.LENGTH_SHORT).show()
                this.feedSpinner()
                dialog.dismiss()
            }
            else {
                Toast.makeText(this, "Se ha producio un error al eliminar el usuario", Toast.LENGTH_SHORT).show()
                dialog.dismiss()
            }
        }
        builder.show()
    }
}