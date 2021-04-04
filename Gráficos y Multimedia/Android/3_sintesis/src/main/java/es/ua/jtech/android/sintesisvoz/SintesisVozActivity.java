package es.ua.jtech.android.sintesisvoz;

import java.util.Locale;

import android.annotation.TargetApi;
import android.app.Activity;
import android.content.Intent;
import android.os.Build;
import android.os.Bundle;
import android.speech.tts.*;
import android.speech.tts.TextToSpeech.Engine;
import android.speech.tts.TextToSpeech.OnInitListener;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.RadioButton;
import android.widget.TextView;
import es.ua.jtech.android.sintesisvoz.R;

public class SintesisVozActivity extends Activity {
	private static int TTS_DATA_CHECK = 1;
    private TextToSpeech tts = null;
    private boolean ttsIsInit = false;
    private RadioButton radioEnglish, radioSpanish;
    private TextView texto;
    private Button leer;

	@Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.main);
        inicializarControles();
        initTextToSpeech();
    }
    
	private void inicializarControles() {
		radioEnglish = (RadioButton)findViewById(R.id.radioEnglish);
		radioSpanish = (RadioButton)findViewById(R.id.radioSpanish);
		texto = (TextView)findViewById(R.id.texto);
		leer = (Button)findViewById(R.id.butRead);
		radioSpanish.setChecked(true);
		
		leer.setOnClickListener(butReadListener);
		radioSpanish.setOnClickListener(radioSpanishListener);
		radioEnglish.setOnClickListener(radioEnglishListener);
	}
	
	private OnClickListener butReadListener = new OnClickListener() {
		public void onClick(View v) {
			speak(texto.getText().toString());
		}
	};
	
	private OnClickListener radioSpanishListener = new OnClickListener() {

		@TargetApi(Build.VERSION_CODES.DONUT)
		public void onClick(View v) {
			radioSpanish.setChecked(true);
			radioEnglish.setChecked(false);
			
			//TODO cambiar el idioma a español
			Locale spanish = new Locale("es", "ES");
			tts.setLanguage(spanish);

		}
		
	};
	
	private OnClickListener radioEnglishListener = new OnClickListener() {

		@TargetApi(Build.VERSION_CODES.DONUT)
		public void onClick(View v) {
			radioSpanish.setChecked(false);
			radioEnglish.setChecked(true);
			
			//TODO cambiar el idioma a inglés
			tts.setLanguage(Locale.ENGLISH);

		}
		
	};
	
    private void initTextToSpeech() {
    	//TODO inicializar motor text to speech
		Intent intent = new Intent(Engine.ACTION_CHECK_TTS_DATA);
		startActivityForResult(intent, TTS_DATA_CHECK);

    }

    @TargetApi(Build.VERSION_CODES.DONUT)
	protected void onActivityResult(int requestCode, int resultCode, Intent data) {
    	//TODO inicialización del motor text to speech
		if (resultCode != Engine.CHECK_VOICE_DATA_PASS) {
			Intent intent = new Intent(Engine.ACTION_INSTALL_TTS_DATA);
			startActivity(intent);
		}
		else {
			tts = new TextToSpeech(this, new OnInitListener() {
				@Override
				public void onInit(int status) {
					if (status == TextToSpeech.SUCCESS) {
						ttsIsInit = true;
					}
				}
			});
		}

    }

    @TargetApi(Build.VERSION_CODES.DONUT)
	private void speak(String texto) {
    	//TODO invocar al método speak del objeto TextToSpeech para leer el texto del EditText
		tts.speak(texto, TextToSpeech.QUEUE_ADD, null);
    }

    @TargetApi(Build.VERSION_CODES.DONUT)
	@Override
    public void onDestroy() {
    	//TODO liberar los recursos de Text to Speech
		tts.shutdown();
    	super.onDestroy();
    }

}