package com.mastermoviles.persistencia.sqlite.Provider

import android.content.ContentProvider
import android.content.ContentValues
import android.content.UriMatcher
import android.database.Cursor
import android.database.sqlite.SQLiteDatabase
import android.database.sqlite.SQLiteQueryBuilder
import android.net.Uri
import android.text.TextUtils
import com.mastermoviles.persistencia.sqlite.Data.Database
import java.lang.IllegalArgumentException

class UsersProvider: ContentProvider() {

    private val USERS = 1
    private val USERS_ID = 2
    private val uriMatcher = UriMatcher(UriMatcher.NO_MATCH)
    private var database: Database? = null

    init {
        uriMatcher.addURI(UsersContract.AUTHORITY, UsersContract.UsersEntry.TABLE_NAME, USERS)
        uriMatcher.addURI(UsersContract.AUTHORITY, UsersContract.UsersEntry.TABLE_NAME + "/#", USERS_ID)
    }

    override fun onCreate(): Boolean {
        database = Database(context!!)
        return true
    }

    override fun query(uri: Uri, projection: Array<out String>?, selection: String?, selectionArgs: Array<out String>?, sortOrder: String?): Cursor? {
        val uriType = uriMatcher.match(uri)
        val db = database!!.readableDatabase
        var where = selection
        if (uriType == USERS_ID) {
            where = "id=" + uri.lastPathSegment
        }
        val cursor = db.query(UsersContract.UsersEntry.TABLE_NAME, projection, where, selectionArgs, null, null, sortOrder)
        cursor.setNotificationUri(context!!.contentResolver, uri)
        return cursor
    }

    override fun insert(uri: Uri, values: ContentValues?): Uri? {
        val uriType = uriMatcher.match(uri)
        val db = database!!.writableDatabase
        val id: Long

        when (uriType) {
            USERS -> id = db.insert(UsersContract.UsersEntry.TABLE_NAME, null, values)
            else -> throw IllegalArgumentException("Unknown URI: $uri")
        }
        context!!.contentResolver.notifyChange(uri, null)
        return  Uri.parse(UsersContract.UsersEntry.TABLE_NAME + "/" + id)
    }

    override fun delete(uri: Uri, selection: String?, selectionArgs: Array<out String>?): Int {
        val uriType = uriMatcher.match(uri)
        val db: SQLiteDatabase = database!!.writableDatabase
        val rowsDeleted: Int

        rowsDeleted = when (uriType) {
            USERS -> db.delete(UsersContract.UsersEntry.TABLE_NAME, selection, selectionArgs)
            USERS_ID -> {
                val id = uri.lastPathSegment
                if (TextUtils.isEmpty(selection)) {
                    db.delete(UsersContract.UsersEntry.TABLE_NAME, UsersContract.UsersEntry.COLUMN_ID + "=" + id, null)
                } else {
                    db.delete(UsersContract.UsersEntry.TABLE_NAME, UsersContract.UsersEntry.COLUMN_ID + "=" + id + " and " + selection, selectionArgs)
                }
            }
            else -> throw IllegalArgumentException("Unknown URI: $uri")
        }
        context!!.contentResolver.notifyChange(uri, null)
        return rowsDeleted
    }

    override fun update(uri: Uri, values: ContentValues?, selection: String?, selectionArgs: Array<out String>?): Int {
        val uriType = uriMatcher.match(uri)
        val db: SQLiteDatabase = database!!.writableDatabase
        val rowsUpdated: Int

        rowsUpdated = when (uriType) {
            USERS -> db.update(UsersContract.UsersEntry.TABLE_NAME, values, selection, selectionArgs)
            USERS_ID -> {
                val id = uri.lastPathSegment
                if (TextUtils.isEmpty(selection)) {
                    db.update(UsersContract.UsersEntry.TABLE_NAME, values, UsersContract.UsersEntry.COLUMN_ID + "=" + id, null)
                } else {
                    db.update(UsersContract.UsersEntry.TABLE_NAME, values, UsersContract.UsersEntry.COLUMN_ID + "=" + id + " and " + selection, selectionArgs)
                }
            }
            else -> throw IllegalArgumentException("Unknown URI: $uri")
        }
        context!!.contentResolver.notifyChange(uri, null)
        return rowsUpdated
    }

    override fun getType(uri: Uri): String? {
        return when (uriMatcher.match(uri)) {
            USERS -> UsersContract.UsersEntry.CONTENT_TYPE
            USERS_ID -> UsersContract.UsersEntry.CONTENT_ITEM_TYPE
            else -> throw IllegalArgumentException("Unknown URI: $uri")
        }
    }
}