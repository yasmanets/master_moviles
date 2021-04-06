package es.ua.eps.mm2021.kotlin.filmoteca

import com.google.android.gms.auth.api.signin.GoogleSignInAccount
import com.google.android.gms.auth.api.signin.GoogleSignInClient

class UserData {
    var gsClient: GoogleSignInClient? = null
    var account: GoogleSignInAccount? = null
}