package com.mastermovilesua.persistencia.sharedpreferences2.Fragments

import android.content.SharedPreferences
import android.graphics.Color
import android.graphics.Typeface
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Button
import android.widget.EditText
import android.widget.RelativeLayout
import android.widget.TextView
import androidx.fragment.app.Fragment
import androidx.preference.PreferenceManager
import com.mastermovilesua.persistencia.sharedpreferences2.R

class MainFragment : Fragment() {

    private var editText: EditText? = null
    private var preview: Button? = null
    private var close: Button? = null
    private var relativeLayout: RelativeLayout? = null
    lateinit var preferences: SharedPreferences

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View? {
        return inflater.inflate(R.layout.fragment_main, container, false)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        this.setUIContent(view)
        this.close?.setOnClickListener {
            activity?.finish()
        }
        this.preview?.setOnClickListener {
            val animatedTV = relativeLayout?.findViewWithTag<TextView>(1521)
            if (animatedTV != null) {
                relativeLayout?.removeView(animatedTV)
            }
            this.setAnimatedTextView()
        }
    }

    private fun setAnimatedTextView() {
        val animatedText = TextView(activity)
        animatedText.tag = 1521
        val params: RelativeLayout.LayoutParams = RelativeLayout.LayoutParams(RelativeLayout.LayoutParams.WRAP_CONTENT, RelativeLayout.LayoutParams.WRAP_CONTENT)
        params.addRule(RelativeLayout.CENTER_HORIZONTAL)
        params.addRule(RelativeLayout.CENTER_VERTICAL)


        animatedText.setPadding(15,15,15,15)
        val size: String = preferences.getString("sizeList", "32")!!
        animatedText.textSize = size.toFloat()
        val color: String = preferences.getString("colorList", "#ff0000").toString()
        if (color.contains('#')) {
            animatedText.setTextColor(Color.parseColor(color))
        }
        else {
            animatedText.setTextColor(Color.RED)
        }
        val background: String = preferences.getString("backgroundList", "#ffffff").toString()
        if (background.contains('#')) {
            animatedText.setBackgroundColor(Color.parseColor(background))
        }
        else {
            animatedText.setBackgroundColor(Color.WHITE)
        }
        if (editText?.text?.isEmpty() == true) animatedText.text = "Hola Mundo" else animatedText.text = editText?.text
        val setBold: Boolean = preferences.getBoolean("boldText", false)
        val setItalic: Boolean = preferences.getBoolean("italicText", false)
        if (setBold && setItalic) {
            animatedText.setTypeface(animatedText.typeface,  Typeface.BOLD_ITALIC)
        }
        else if (setBold && !setItalic) {
            animatedText.setTypeface(animatedText.typeface,  Typeface.BOLD)
        }
        else if (!setBold && setItalic) {
            animatedText.setTypeface(animatedText.typeface,  Typeface.ITALIC)
        }
        else {
            animatedText.setTypeface(animatedText.typeface,  Typeface.NORMAL)
        }
        val alpha: Float = preferences.getFloat("alphaValue", 1F)
        val rotation: Float = preferences.getInt("rotation", 45).toFloat()
        animatedText.alpha = alpha
        animatedText.animate().rotation(rotation).duration = 3000
        relativeLayout?.addView(animatedText, params)
    }

    private fun setUIContent(view: View) {
        this.editText = view.findViewById(R.id.editText)
        this.preview = view.findViewById(R.id.preview)
        this.close = view.findViewById(R.id.close)
        this.relativeLayout = view.findViewById(R.id.mainFragmentLayout)
        this.preferences = PreferenceManager.getDefaultSharedPreferences(activity)
    }
 }