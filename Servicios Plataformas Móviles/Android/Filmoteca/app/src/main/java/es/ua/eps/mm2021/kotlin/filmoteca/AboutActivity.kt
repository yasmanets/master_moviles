package es.ua.eps.mm2021.kotlin.filmoteca

import android.content.Intent
import android.net.Uri
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.widget.Button
import android.widget.TextView

class AboutActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_about)

        supportActionBar?.setDisplayHomeAsUpEnabled(true)

        val webButton = findViewById<Button>(R.id.webButton)
        val supportButton = findViewById<Button>(R.id.supportButton)
        val backButton = findViewById<Button>(R.id.backButton)
        val googleData = findViewById<TextView>(R.id.googleData)
        val account = user.account

        googleData.text = String.format(" Id: %s \nName %s \nEmail %s", account?.id, account?.givenName, account?.email)

        webButton.setOnClickListener {
            val webIntent = Intent(Intent.ACTION_VIEW, Uri.parse("https://www.ulompi.cards"))
            if (webIntent.resolveActivity(packageManager) != null) {
                startActivity(webIntent)
            }
        }
        supportButton.setOnClickListener {
            val mailIntent = Intent(Intent.ACTION_SENDTO, Uri.parse("mailto:yaser.94ae@gmail.com"))
            if (mailIntent.resolveActivity(packageManager) != null) {
                startActivity(mailIntent)
            }
        }
        backButton.setOnClickListener {
            finish()
        }
    }
}