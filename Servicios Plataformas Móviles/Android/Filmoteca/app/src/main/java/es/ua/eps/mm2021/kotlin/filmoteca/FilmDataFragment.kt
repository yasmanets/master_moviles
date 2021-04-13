package es.ua.eps.mm2021.kotlin.filmoteca

import android.app.Activity
import android.app.AlertDialog
import android.app.Application
import android.content.Context
import android.content.DialogInterface
import android.content.Intent
import android.content.SharedPreferences
import android.net.Uri
import android.os.AsyncTask
import android.os.Bundle
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.*
import androidx.fragment.app.Fragment
import androidx.fragment.app.FragmentManager
import com.github.scribejava.apis.TwitterApi
import com.github.scribejava.core.builder.ServiceBuilder
import com.github.scribejava.core.model.OAuth1AccessToken
import com.github.scribejava.core.model.OAuth1RequestToken
import com.github.scribejava.core.model.OAuthRequest
import com.github.scribejava.core.model.Verb
import com.github.scribejava.core.oauth.OAuth10aService
import com.github.scribejava.core.oauth.OAuth20Service
import com.github.scribejava.core.oauth.OAuthService
import com.google.gson.Gson
import es.ua.eps.mm2021.kotlin.filmoteca.film.FilmDataSource
import org.json.JSONObject
import java.lang.Exception
import java.util.concurrent.Future

private const val EDIT_ACTIVITY_CODE = 1

class FilmDataFragment : Fragment() {

    private var filmImage: ImageView? = null
    private var filmTitle: TextView? = null
    private var directorName: TextView? = null
    private var filmYear: TextView? = null
    private var filmType: TextView? = null
    private var showIMDB: Button? = null
    private var editMovie: Button? = null
    private var goToMain: Button? = null
    private var imdbLink: String? = ""
    private var filmComments: TextView? = null
    private var twitter: Button? = null
    private var maps: Button? = null
    private var pinCode: String = ""
    private lateinit var requestToken: OAuth1RequestToken
    private lateinit var service: OAuth10aService
    private lateinit var preferences: SharedPreferences
    private lateinit var editor: SharedPreferences.Editor
    private var longitude: Double = 0.0
    private var latitude: Double = 0.0

    override fun onCreateView(inflater: LayoutInflater,
                              container: ViewGroup?,
                              savedInstanceState: Bundle?): View? {
        return inflater.inflate(R.layout.activity_film_data, container, false)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        activity?.actionBar?.setDisplayHomeAsUpEnabled(true)

        val position = arguments?.getInt(FILM_CLICKED)
        val intent = activity?.intent
        getReferences(view)
        if (position != null) {
            setSelectedFilm(position)
        }

        editMovie?.setOnClickListener {
            val editIntent = Intent(view.context, FilmEditActivity::class.java)
            editIntent.putExtra(FILM_CLICKED, intent?.getIntExtra(FILM_CLICKED, 0))
            startActivityForResult(editIntent, EDIT_ACTIVITY_CODE)
        }
        goToMain?.setOnClickListener {
            val mainIntent = Intent(view.context, MainActivity::class.java)
            mainIntent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP)
            startActivity(mainIntent)
        }
        showIMDB?.setOnClickListener {
            val imdbIntent = Intent(Intent.ACTION_VIEW, Uri.parse(imdbLink))
            if (imdbIntent.resolveActivity(activity?.packageManager!!) != null) {
                startActivity(imdbIntent)
            }
        }
        twitter?.setOnClickListener {
            if (preferences.contains("token")) {
                PublishTweet().execute()
            }
            else {
                TwitterTask().execute()
            }
        }

        maps?.setOnClickListener {
            val mapIntent = Intent(view.context, MapsActivity::class.java)
            mapIntent.putExtra("title", filmTitle?.text)
            mapIntent.putExtra("director", directorName?.text)
            mapIntent.putExtra("year", Integer.parseInt(filmYear?.text as String))
            mapIntent.putExtra("latitude", latitude)
            mapIntent.putExtra("longitude", longitude)
            startActivity(mapIntent)
        }
    }

    private fun getReferences(view: View) {
        filmImage = view.findViewById(R.id.filmImage)
        filmTitle = view.findViewById(R.id.filmTitle)
        directorName = view.findViewById(R.id.directorName)
        filmYear = view.findViewById(R.id.year)
        filmType = view.findViewById(R.id.filmType)
        filmComments = view.findViewById(R.id.comments)
        showIMDB = view.findViewById(R.id.showIMDB)
        editMovie = view.findViewById(R.id.editFilm)
        goToMain = view.findViewById(R.id.goMain)
        twitter = view.findViewById(R.id.twitter)
        maps = view.findViewById(R.id.maps)
        preferences = activity?.getSharedPreferences("preferences", Context.MODE_PRIVATE)!!
        editor = preferences.edit()
    }

    private fun setViewContent(intent: Intent) {
        val films = FilmDataSource.films
        val position = intent.getIntExtra(FILM_CLICKED, 0)
        filmImage?.setImageResource(films[position].imageResId)
        filmTitle?.text = films[position].title
        directorName?.text = films[position].director
        filmYear?.text = films[position].year.toString()
        filmType?.text = String.format(getType(films[position].format) + ", " + getGender(films[position].genre))
        imdbLink = films[position].imdbUrl
        filmComments?.text = films[position].comments
        latitude = films[position].latitude!!
        longitude = films[position].longitude!!
        Log.d("FIlmoteca", "1 lat ${films[position]}")
        Log.d("FIlmoteca", "1 long ${films[position].latitude}")
    }

    private fun getType(position: Int): String {
        return when (position) {
            0 -> "DVD"
            1 -> "Bluray"
            2 -> "Digital"
            else -> ""
        }
    }

    private fun getGender(position: Int): String {
        return when (position) {
            0 -> getText(R.string.action).toString()
            1 -> getText(R.string.comedy).toString()
            2 -> getText(R.string.drama).toString()
            3 -> getText(R.string.scifi).toString()
            4 -> getText(R.string.terror).toString()
            else -> ""
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        when (resultCode) {
            Activity.RESULT_OK -> {
                setViewContent(activity?.intent!!)
                Toast.makeText(view?.context, getString(R.string.edited, filmTitle?.text), Toast.LENGTH_LONG)
                    .show()
            }
        }
    }

    fun setSelectedFilm(position: Int) {
        val films = FilmDataSource.films
        filmImage?.setImageResource(films[position].imageResId)
        filmTitle?.text = films[position].title
        directorName?.text = films[position].director
        filmYear?.text = films[position].year.toString()
        filmType?.text = String.format(getType(films[position].format) + ", " + getGender(films[position].genre))
        imdbLink = films[position].imdbUrl
        filmComments?.text = films[position].comments
        latitude = films[position].latitude!!
        longitude = films[position].longitude!!
    }

    inner class TwitterTask: AsyncTask<String, Int, Int>() {
        override fun onPreExecute() {
            super.onPreExecute()
            val inflater = LayoutInflater.from(activity)
            val view = inflater.inflate(R.layout.dialog_view, null)

            val alertDialog = AlertDialog.Builder(activity)
            alertDialog.setView(view)
            alertDialog.setPositiveButton("OK", ({ _: DialogInterface, _: Int ->
                pinCode = view.findViewById<EditText>(R.id.editPin).text.toString()
                GetAccessToken().execute()
            }))
            alertDialog.show()
        }

        override fun doInBackground(vararg p0: String?): Int {
            service = ServiceBuilder("UGca9tUwLW3j6PgesL4r18CfL").apiSecret("5xZKl2HUKqA3EuYsdDauytKkilxGHtvdrsYRS7504nOTWYCIpx")
                .callback("oob")
                .build(TwitterApi.instance())

            requestToken = service.requestToken
            val authUrl = service.getAuthorizationUrl(requestToken)
            val intent = Intent(Intent.ACTION_VIEW, Uri.parse(authUrl))
            startActivity(intent)
            return 1
        }
    }

    inner class GetAccessToken: AsyncTask<String, Int, Int>() {
        override fun doInBackground(vararg p0: String?): Int {
            val accessToken: OAuth1AccessToken = service.getAccessToken(requestToken, pinCode)
            val gson = Gson()
            val token = gson.toJson(accessToken)
            editor.putString("token", token).apply()
            val request = OAuthRequest(Verb.GET, "https://api.twitter.com/1.1/account/verify_credentials.json")
            service.signRequest(accessToken, request)
            return try {
                val repsonse = service?.execute(request)
                Log.d("FIlmoteca", "res1: $repsonse")
                1
            } catch (e: Exception) {
                e.printStackTrace()
                0
            }
        }
    }

    inner class PublishTweet: AsyncTask<String, Int, Int>() {
        override fun doInBackground(vararg p0: String?): Int {
            service = ServiceBuilder("UGca9tUwLW3j6PgesL4r18CfL").apiSecret("5xZKl2HUKqA3EuYsdDauytKkilxGHtvdrsYRS7504nOTWYCIpx").build(TwitterApi.instance())
            val token = preferences.getString("token", "")
            val gson = Gson()
            val accessToken = gson.fromJson(token, OAuth1AccessToken::class.java) ?: return 0
            val tweet = "${filmTitle?.text} es una de mis películas favoritas de la ${getString(R.string.app_name)}"
            val request = OAuthRequest(Verb.POST,"https://api.twitter.com/1.1/statuses/update.json?status=$tweet ")
            service.signRequest(accessToken, request)
            return try {
                val response = service.execute(request)
                Log.d("FIlmoteca", "res: $response")
                1
            } catch (e: Exception) {
                e.printStackTrace()
                0
            }
        }

        override fun onPostExecute(result: Int?) {
            super.onPostExecute(result)
            if (result === 1) {
                Toast.makeText(activity, "Tweet enviado con éxito", Toast.LENGTH_LONG).show()
            }
            else {
                Toast.makeText(activity, "Se ha producido un error al enviar el tweet", Toast.LENGTH_LONG).show()
            }

        }
    }
}

