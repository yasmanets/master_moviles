package es.ua.eps.video;

import java.io.File;
import java.io.IOException;

import android.Manifest;
import android.annotation.TargetApi;
import android.app.Activity;
import android.hardware.Camera;
import android.media.MediaDescrambler;
import android.media.MediaRecorder;
import android.os.Build;
import android.os.Bundle;
import android.os.Environment;
import android.util.Log;
import android.view.SurfaceHolder;
import android.view.SurfaceView;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;

// TODO: añadir los permisos en el Manifest - ok

// TODO: la clase debe implementar la interfaz SurfaceHolder.Callback
public class VideoActivity extends Activity implements SurfaceHolder.Callback {

	SurfaceView superficie;
	Button parar, grabar;
	SurfaceHolder m_holder;

	boolean preparado = false;

	private int REQUEST_CODE = 200;

	// TODO: añadimos un objeto privado MediaRecorder
	private MediaRecorder mediaRecorder;

	@TargetApi(Build.VERSION_CODES.O)
	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.main);
		inicializarInterfaz();

		if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
			requestPermissions(new String[] {Manifest.permission.RECORD_AUDIO, Manifest.permission.CAMERA, Manifest.permission.WRITE_EXTERNAL_STORAGE }, 200);
		}

		// TODO: inicializamos el objeto mediaRecorder
		mediaRecorder = new MediaRecorder();

		// TODO: obtenemos el holder de la superficie y añadimos el manejador
		superficie = (SurfaceView) findViewById(R.id.superficie);
		m_holder = superficie.getHolder();
		m_holder.addCallback(this);
	}

	private void inicializarInterfaz() {
		superficie = (SurfaceView)findViewById(R.id.superficie);
		parar = (Button)findViewById(R.id.parar);
		grabar = (Button)findViewById(R.id.grabar);

		grabar.setOnClickListener(new ManejadorBotonGrabar());
		parar.setOnClickListener(new ManejadorBotonParar());
	}

	private class ManejadorBotonParar implements OnClickListener {
		public void onClick(View v) {
			parar.setEnabled(false);
			grabar.setEnabled(true);

			// TODO: detener la grabación
			mediaRecorder.stop();
		}
	};

	private class ManejadorBotonGrabar implements OnClickListener {
		public void onClick(View v) {

			if (preparado) {
				parar.setEnabled(true);
				grabar.setEnabled(false);

				// TODO: iniciar la grabación
				mediaRecorder.start();
			}
		}
	}

	@Override
	public void surfaceCreated(SurfaceHolder surfaceHolder) {
		if (mediaRecorder != null) {
			try {
				configurar(m_holder);
			}
			catch (IllegalArgumentException e) {
				Log.d("MEDIA_PLAYER", e.getMessage());
			}
			catch (IllegalStateException e) {
				Log.d("MEDIA_PLAYER", e.getMessage());
			}
		}
	}

	public void surfaceChanged(SurfaceHolder holder, int format, int width,
							   int height) {
		Log.d("MEDIA_PLAYER", "surfaceChanged");
	}

	@Override
	public void surfaceDestroyed(SurfaceHolder surfaceHolder) {
		if (mediaRecorder != null) {
			mediaRecorder.release();
		}
	}

	@TargetApi(Build.VERSION_CODES.O)
	private void configurar(SurfaceHolder holder) {
		// TODO: configurar mediaRecorder
		mediaRecorder.setAudioSource(MediaRecorder.AudioSource.MIC);
		mediaRecorder.setVideoSource(MediaRecorder.VideoSource.CAMERA);
		mediaRecorder.setOutputFormat(MediaRecorder.OutputFormat.DEFAULT);
		mediaRecorder.setAudioEncoder(MediaRecorder.AudioEncoder.DEFAULT);
		mediaRecorder.setVideoEncoder(MediaRecorder.VideoEncoder.DEFAULT);
		mediaRecorder.setOutputFile(new File(Environment.getExternalStorageDirectory(), "video.mp4"));
		mediaRecorder.setPreviewDisplay(m_holder.getSurface());
		try {
			mediaRecorder.prepare();
			preparado = true;
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	@Override
	public void onRequestPermissionsResult(int requestCode, String[] permissions, int[] grantResults) {
		super.onRequestPermissionsResult(requestCode, permissions, grantResults);
		if (requestCode != REQUEST_CODE) {
			finish();
		}
	}
}