package com.mastermoviles.persistencia.sqlite

import android.content.Context
import android.content.Intent
import android.os.Build
import android.os.Bundle
import android.os.Environment
import android.util.Log
import android.view.Menu
import android.view.MenuItem
import android.widget.Button
import android.widget.EditText
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import com.mastermoviles.persistencia.sqlite.Data.Database
import com.mastermoviles.persistencia.sqlite.Models.Users
import com.mastermoviles.persistencia.sqlite.UserManagement.ManagementActivity
import com.mastermoviles.persistencia.sqlite.UserManagement.UserActivity
import java.io.*

class MainActivity : AppCompatActivity() {

    var userName: EditText? = null
    var password: EditText? = null
    var login: Button? = null
    var close: Button? = null
    val database = Database(this)

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
        val user: Users? = database.login(name)
        return when {
            user == null -> {
                Toast.makeText(this, "No existe ningún usuario con ese nombre", Toast.LENGTH_SHORT).show()
                false
            }
            user.password != pass -> {
                Toast.makeText(this, "La contraseña no es correcta", Toast.LENGTH_SHORT).show()
                false
            }
            else -> {
                val intent = Intent(this, UserActivity::class.java)
                intent.putExtra("fullName", user.nombre_completo)
                intent.putExtra("userName", user.nombre_usuario)
                startActivity(intent)
                true
            }
        }
    }

    private fun checkExternalStatus(): Boolean {
        return if (Environment.getExternalStorageState() == Environment.MEDIA_MOUNTED) {
            true
        } else if (Environment.getExternalStorageState() == Environment.MEDIA_MOUNTED_READ_ONLY) {
            false
        } else {
            false
        }
    }

    private fun backup() {
        if (checkExternalStatus()) {
            val users = database.getUsers()
            try {
                val fileOutput = OutputStreamWriter(openFileOutput("practicaSQLite.txt", Context.MODE_PRIVATE))
                users.forEach { u->
                    fileOutput.append("${u.id}-${u.nombre_usuario}-${u.password}-${u.nombre_completo}-${u.email}\n")
                }
                fileOutput.close()
                Toast.makeText(this, "Backup creado con éxito", Toast.LENGTH_SHORT).show()
            }
            catch(ex: IOException) {
                ex.printStackTrace()
            }
        }
        else {
            Toast.makeText(this,"No se puede acceder al almacenamiento externo", Toast.LENGTH_SHORT).show()
        }
    }

    private fun restore() {
        if (checkExternalStatus()) {
            try {
                val fileInput = BufferedReader(InputStreamReader(openFileInput("practicaSQLite.txt")))
                var line = fileInput.readLine()
                while (line != null) {
                    val values = line.split("-")
                    Log.d("Main", "" + values[1])
                    val user = Users(null, values[1], values[2], values[3], values[4])
                    val isAdded = database.addUser(user)
                    line = fileInput.readLine()
                }
                fileInput.close()
                Toast.makeText(this, "Backup restaurado con éxito", Toast.LENGTH_SHORT).show()
            }
            catch(ex: IOException) {
                ex.printStackTrace()
                Toast.makeText(this, "No se puede abrir o no existe el backup", Toast.LENGTH_SHORT).show()
            }
        }
        else {
            Toast.makeText(this,"No se puede acceder al almacenamiento externo", Toast.LENGTH_SHORT).show()
        }
    }

    override fun onCreateOptionsMenu(menu: Menu?): Boolean {
        menuInflater.inflate(R.menu.menu, menu)
        return true
    }

    override fun onOptionsItemSelected(item: MenuItem): Boolean {
        when (item.itemId) {
            R.id.backup -> this.backup()
            R.id.restore -> this.restore()
            R.id.users -> {
                val intent = Intent(this, ManagementActivity::class.java)
                startActivity(intent)
            }
            else -> Toast.makeText(this, "No existe la opción seleccionada", Toast.LENGTH_SHORT).show()
        }
        return true
    }
}