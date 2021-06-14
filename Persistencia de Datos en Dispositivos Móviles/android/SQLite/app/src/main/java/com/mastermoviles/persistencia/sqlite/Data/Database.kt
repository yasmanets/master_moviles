package com.mastermoviles.persistencia.sqlite.Data

import android.content.ContentValues
import android.content.Context
import android.database.Cursor
import android.database.sqlite.SQLiteDatabase
import android.database.sqlite.SQLiteException
import android.database.sqlite.SQLiteOpenHelper
import com.mastermoviles.persistencia.sqlite.Models.Users

class Database(context: Context): SQLiteOpenHelper(context, DATABASE_NAME, null, VERSION) {
    companion object {
        private val VERSION = 1
        private val DATABASE_NAME = "practicaSQLite"
        lateinit var CONTEXT: Context
        val USERS_TABLE = "Usuarios"
    }

    override fun onCreate(db: SQLiteDatabase?) {
        val CREATE_USERS_TABLE = ("CREATE TABLE " + USERS_TABLE + "( " +
                "ID INTEGER PRIMARY KEY AUTOINCREMENT, " +
                "nombre_usuario TEXT, " +
                "password TEXT, " +
                "nombre_completo TEXT, " +
                "email TEXT " +
            ")")
        db?.execSQL(CREATE_USERS_TABLE)
    }

    override fun onUpgrade(db: SQLiteDatabase?, oldVersion: Int, newVersion: Int) {
        db!!.execSQL("DROP TABLE IF EXISTS $USERS_TABLE")
        onCreate(db)
    }

    // CRUD
    fun addUser(user: Users): Long {
        val db = this.writableDatabase
        val contentValues = ContentValues()
        contentValues.put("nombre_usuario", user.nombre_usuario)
        contentValues.put("password", user.password)
        contentValues.put("nombre_completo", user.nombre_completo)
        contentValues.put("email", user.email)

        val success = db.insert(USERS_TABLE, null, contentValues)
        db.close()
        return success
    }

    fun getUser(userId: Int): Users? {
        val select = "SELECT * FROM $USERS_TABLE WHERE id=$userId"
        val db = this.readableDatabase
        db.rawQuery(select, null).use {
            if (it.moveToFirst()) {
                val id = it.getInt(it.getColumnIndex("ID"))
                val userName = it.getString(it.getColumnIndex("nombre_usuario"))
                val password = it.getString(it.getColumnIndex("password"))
                val fullName = it.getString(it.getColumnIndex("nombre_completo"))
                val email = it.getString(it.getColumnIndex("email"))
                return  Users(id = id, nombre_usuario = userName, password = password, nombre_completo = fullName, email = email)
            }
            return null
        }
    }

    fun login(userName: String): Users? {
        val select = "SELECT * FROM $USERS_TABLE WHERE nombre_usuario='$userName'"
        val db = this.readableDatabase
        db.rawQuery(select, null).use {
            if (it.moveToFirst()) {
                val id = it.getInt(it.getColumnIndex("ID"))
                val userName = it.getString(it.getColumnIndex("nombre_usuario"))
                val password = it.getString(it.getColumnIndex("password"))
                val fullName = it.getString(it.getColumnIndex("nombre_completo"))
                val email = it.getString(it.getColumnIndex("email"))
                return  Users(id = id, nombre_usuario = userName, password = password, nombre_completo = fullName, email = email)
            }
            return null
        }
    }

    fun getUsers(): List<Users> {
        val usersList: ArrayList<Users> = ArrayList()
        val select = "SELECT * FROM $USERS_TABLE"
        val db = this.readableDatabase
        var cursor: Cursor? = null
        try {
            cursor = db.rawQuery(select, null)
        }
        catch (ex: SQLiteException) {
            db.execSQL(select)
            return ArrayList()
        }
        var id: Int
        var userName: String
        var password: String
        var fullName: String
        var email: String
        if (cursor.moveToFirst()) {
            do {
                id = cursor.getInt(cursor.getColumnIndex("ID"))
                userName = cursor.getString(cursor.getColumnIndex("nombre_usuario"))
                password = cursor.getString(cursor.getColumnIndex("password"))
                fullName = cursor.getString(cursor.getColumnIndex("nombre_completo"))
                email = cursor.getString(cursor.getColumnIndex("email"))
                val user = Users(id = id, nombre_usuario = userName, password = password, nombre_completo = fullName, email = email)
                usersList.add(user)
            }
            while (cursor.moveToNext())
        }
        db.close()
        return usersList
    }

    fun updateUser(user: Users): Int {
        val db = this.writableDatabase
        val contentValues = ContentValues()
        contentValues.put("nombre_usuario", user.nombre_usuario)
        contentValues.put("nombre_completo", user.nombre_completo)
        contentValues.put("password", user.password)
        contentValues.put("email", user.email)

        val success = db.update(USERS_TABLE, contentValues,"id=${user.id}", null)
        db.close()
        return success
    }

    fun deleteUser(user: Users): Int {
        val db = this.writableDatabase
        val contentValues = ContentValues()
        contentValues.put("id", user.id)

        val success = db.delete(USERS_TABLE, "id=${user.id}", null)
        db.close()
        return success
    }

}