package es.ua.jtech.android.multimedia;

import android.app.Activity;
import android.media.MediaPlayer;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;

import java.io.IOException;

public class AudioActivity extends Activity {

    Button reproducir, pausa, detener;
    MediaPlayer mediaPlayer;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.main);

        // TODO: inicializar el objeto MediaPlayer
        mediaPlayer = new MediaPlayer().create(this, R.raw.zelda_nes);
        inicializarBotones();
    }

    private void inicializarBotones() {
        reproducir = (Button)findViewById(R.id.reproducir);
        pausa = (Button)findViewById(R.id.pausa);
        detener = (Button)findViewById(R.id.detener);

        reproducir.setOnClickListener(new OnClickListener() {
            public void onClick(View v) {
                // TODO habilitar los botones Pausa y Detener, deshabilitar el botón Reproducir
                pausa.setEnabled(true);
                detener.setEnabled(true);
                reproducir.setEnabled(false);
                // TODO iniciar la reproducción del clip de audio
                mediaPlayer.start();
            }
        });

        pausa.setOnClickListener(new OnClickListener() {
            public void onClick(View v) {
                // TODO pausar o reanudar la reproducción del audio
                // TODO cambiar el texto del botón a Reanudar o Pausa según corresponda
                if (mediaPlayer.isPlaying()) {
                    mediaPlayer.pause();
                    pausa.setText("Reanudar");
                }
                else {
                    mediaPlayer.start();
                    pausa.setText("Pausa");
                }

            }
        });

        detener.setOnClickListener(new OnClickListener() {
            public void onClick(View v) {
                // TODO habilitar el botón Reproducir, deshabilitar los botones Pausa y Detener
                reproducir.setEnabled(true);
                pausa.setEnabled(false);
                detener.setEnabled(false);
                pausa.setText("Pausa");
                // TODO volver a poner como texto del botón de pausa la cadena Pausa
                mediaPlayer.stop();
                try {
                    mediaPlayer.prepare();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        });
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        // TODO liberar los recursos asociados al objeto MediaPlayer
        if (mediaPlayer != null) {
            mediaPlayer.release();
            mediaPlayer = null;
        }
    }
}
