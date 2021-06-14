package com.mastermovilesua.persistencia.preferencias.sharedpreferences1.Base64Kotlin

import android.util.Base64

object Base64Cipher {
    fun encryptData(data: String): String {
        return Base64.encodeToString(data?.toByteArray(), Base64.DEFAULT)
    }

    fun decryptData(data: String): String {
        return String(Base64.decode(data?.toByteArray(), Base64.DEFAULT))
    }
}