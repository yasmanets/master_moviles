package com.mastermovilesua.persistencia.sharedpreferences2

import android.content.Context
import android.content.res.TypedArray
import android.util.AttributeSet
import android.util.Log
import android.widget.SeekBar
import android.widget.TextView
import androidx.preference.Preference
import androidx.preference.PreferenceViewHolder

class FloatSeekBarPreference(context: Context, attrs: AttributeSet?, defStyleAttr: Int, defStyleRes: Int) :
    Preference(context, attrs, defStyleAttr, defStyleRes), SeekBar.OnSeekBarChangeListener {

    var value: Float
        get() = (seekbar?.progress?.times(valueSpacing) ?: 0F) + minValue
        set(v) {
            newValue = v
            persistFloat(v)
            notifyChanged()
        }

    private val minValue: Float
    private val maxValue: Float
    private val valueSpacing: Float
    private val format: String

    private var seekbar: SeekBar? = null
    private var textView: TextView? = null

    private var defaultValue = 1F
    private var newValue = 0F

    constructor(context: Context, attrs: AttributeSet?, defStyleAttr: Int) : this(context, attrs, defStyleAttr, 0)
    constructor(context: Context, attrs: AttributeSet?) : this(context, attrs, R.attr.seekBarPreferenceStyle)
    constructor(context: Context) : this(context, null)

    init {
        widgetLayoutResource = R.layout.pref_float_seekbar

        // XMLの値を取得
        val ta = context.obtainStyledAttributes(attrs, R.styleable.FloatSeekBarPreference, defStyleAttr, defStyleRes)
        minValue = ta.getFloat(R.styleable.FloatSeekBarPreference_minValue, 0F)
        maxValue = ta.getFloat(R.styleable.FloatSeekBarPreference_maxValue, 1F)
        valueSpacing = ta.getFloat(R.styleable.FloatSeekBarPreference_valueSpacing, .1F)
        format = ta.getString(R.styleable.FloatSeekBarPreference_format) ?: "%3.1f"
        ta.recycle()
    }

    override fun onGetDefaultValue(ta: TypedArray?, i: Int): Any {
        defaultValue = ta!!.getFloat(i, 0F)
        return defaultValue
    }

    override fun onSetInitialValue(initValue: Any?) {
        Log.d("Main", "" + initValue)
        newValue = getPersistedFloat(
            if (initValue is Float) initValue
            else this.defaultValue
        )
    }

    override fun onBindViewHolder(holder: PreferenceViewHolder?) {
        super.onBindViewHolder(holder)

        holder!!.itemView.isClickable = false
        seekbar = holder.findViewById(R.id.seekbar) as SeekBar
        textView = holder.findViewById(R.id.seekbar_value) as TextView

        seekbar!!.setOnSeekBarChangeListener(this)
        seekbar!!.max = ((maxValue - minValue) / valueSpacing).toInt()
        seekbar!!.progress = ((newValue - minValue) / valueSpacing).toInt()
        seekbar!!.isEnabled = isEnabled

        textView!!.text = format.format(newValue)
    }

    override fun onProgressChanged(seekbar: SeekBar?, progress: Int, fromUser: Boolean) {
        if (!fromUser) return
        val v = minValue + progress * valueSpacing
        textView!!.text = format.format(v)
    }

    override fun onStartTrackingTouch(seekbar: SeekBar?) {}

    override fun onStopTrackingTouch(seekbar: SeekBar?) {
        val v = minValue + seekbar!!.progress * valueSpacing
        persistFloat(v)
    }
}