package com.mastermovilesua.persistencia.preferencias.sharedpreferences1.Base64Java;

import android.util.Base64;

public class Base64Cipher {
    public static String encryptData(String data) {
        return Base64.encodeToString(data.getBytes(), Base64.DEFAULT);
    }

    public static String decryptData(String data) {
        return new String(Base64.decode(data.getBytes(), Base64.DEFAULT));
    }
}
