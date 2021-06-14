package com.mastermoviles.persistencia.sqlite.Provider

import android.content.ContentResolver
import android.net.Uri
import android.provider.BaseColumns

object UsersContract {
    const val AUTHORITY = "com.mastermoviles.persistencia.sqlite.Provider.UsersProvider"
    val BASE_URI = Uri.parse("content://$AUTHORITY")
    const val PATH_USERS = "users"

    object UsersEntry: BaseColumns {
        const val TABLE_NAME = "Usuarios"
        const val COLUMN_ID = "id"
        const val COLUMN_NOMBRE_USUARIO = "nombre_usuario"
        const val COLUMN_PASSWORD = "password"
        const val NOMBRE_COMPLETO = "nombre_completo"
        const val COLUMN_EMAIL = "email"
        val CONTENT_URI = BASE_URI.buildUpon().appendPath(PATH_USERS).build()

        const val CONTENT_TYPE = "${ContentResolver.CURSOR_DIR_BASE_TYPE}/${AUTHORITY}/${PATH_USERS}"
        const val CONTENT_ITEM_TYPE = "${ContentResolver.CURSOR_ITEM_BASE_TYPE}/${AUTHORITY}/${PATH_USERS}"
    }

}