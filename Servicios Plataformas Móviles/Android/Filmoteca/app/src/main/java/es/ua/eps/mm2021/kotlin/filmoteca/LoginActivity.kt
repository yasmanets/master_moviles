package es.ua.eps.mm2021.kotlin.filmoteca

import android.content.Context
import android.content.Intent
import android.os.Bundle
import android.util.Log
import androidx.appcompat.app.AppCompatActivity
import com.google.android.gms.ads.AdListener
import com.google.android.gms.ads.AdRequest
import com.google.android.gms.ads.InterstitialAd
import com.google.android.gms.ads.MobileAds
import com.google.android.gms.auth.api.signin.GoogleSignIn
import com.google.android.gms.auth.api.signin.GoogleSignInAccount
import com.google.android.gms.auth.api.signin.GoogleSignInClient
import com.google.android.gms.auth.api.signin.GoogleSignInOptions
import com.google.android.gms.common.SignInButton
import com.google.android.gms.common.api.ApiException
import com.google.android.gms.tasks.Task
import kotlinx.android.synthetic.main.activity_login.*

const val PLAY_SERVICES_SIGN_IN = 1
val user = UserData()

class LoginActivity : AppCompatActivity() {

    private lateinit var mInterstitialAd: InterstitialAd
    private lateinit var loginContext: Context

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_login)

        this.loginContext = this.applicationContext
        MobileAds.initialize(this, "ca-app-pub-3940256099942544~3347511713")
        mInterstitialAd = InterstitialAd(this)
        mInterstitialAd.adUnitId = "ca-app-pub-3940256099942544/1033173712"
        mInterstitialAd.adListener = object: AdListener() {
            override fun onAdClosed() {
                super.onAdClosed()
                var intent = Intent(loginContext, MainActivity::class.java)
                intent = this@LoginActivity.notification(intent)
                startActivity(intent)
            }

            override fun onAdLoaded() {
                super.onAdLoaded()
                mInterstitialAd.show()
                signInButton.isEnabled = true
            }
        }

        val signIn = findViewById<SignInButton>(R.id.signInButton)
        signIn.setSize(SignInButton.SIZE_STANDARD)
        val gso: GoogleSignInOptions = GoogleSignInOptions.Builder(GoogleSignInOptions.DEFAULT_SIGN_IN)
            .requestId()
            .requestProfile()
            .requestEmail()
            .build()
        val mGoogleSigInClient = GoogleSignIn.getClient(this, gso)

        user.gsClient = mGoogleSigInClient
        signIn.setOnClickListener {
            signIn(mGoogleSigInClient)
        }
    }

    override fun onStart() {
        super.onStart()
        val account : GoogleSignInAccount ? = GoogleSignIn.getLastSignedInAccount(this)
        handleAccount(account)
    }

    private fun signIn(signInClient: GoogleSignInClient) {
        val intent: Intent? = signInClient.signInIntent
        startActivityForResult(intent, PLAY_SERVICES_SIGN_IN)
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == PLAY_SERVICES_SIGN_IN) {
            val task: Task<GoogleSignInAccount> = GoogleSignIn.getSignedInAccountFromIntent(data)
            handleSignInResult(task)
        }
    }

    private fun handleSignInResult(completedTask: Task<GoogleSignInAccount>) {
        try {
            val account: GoogleSignInAccount? = completedTask.result
            handleAccount(account)
        }
        catch (e: ApiException) {
            Log.d("LoginActivity", "SignInResult failed: ${e.statusCode}")
        }
    }

    private fun handleAccount(account: GoogleSignInAccount?) {
        if (account != null) {
            user.account = account
            signInButton.isEnabled = false
            mInterstitialAd.loadAd(AdRequest.Builder().build())
        }
    }

    private fun notification(mainIntent: Intent): Intent {
        val action: String = intent.getStringExtra("action") ?: return mainIntent
        val title: String = intent.getStringExtra("title") ?: ""
        val director: String = intent.getStringExtra("director") ?: ""
        val year: Int = Integer.parseInt(intent.getStringExtra("year")?: "0")
        val genre: Int = Integer.parseInt(intent.getStringExtra("genre")?: "0")
        val format: Int = Integer.parseInt(intent.getStringExtra("format")?: "0")
        val imdbUrl: String = intent.getStringExtra("imdbUrl") ?: ""

        mainIntent.putExtra("action", action)
        mainIntent.putExtra("title", title)
        mainIntent.putExtra("director", director)
        mainIntent.putExtra("year", year)
        mainIntent.putExtra("genre", genre)
        mainIntent.putExtra("format", format)
        mainIntent.putExtra("imdbUrl", imdbUrl)

        return mainIntent
    }
}