package com.mastermoviles.persistencia.files;

import androidx.appcompat.app.AppCompatActivity;

import android.os.Bundle;
import android.os.Environment;
import android.widget.Button;
import android.widget.TextView;

public class ExternalActivity extends AppCompatActivity {

    private TextView storageInfo;
    private Button goBack;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_external);

        storageInfo = findViewById(R.id.externalStateTextView);
        goBack = findViewById(R.id.goMain);
        storageInfo.setText("No se puede acceder a la información de almacenamiento externo.");
        if (isExternalStorageReadable()) {
            this.setTextViewContent();
        }
        goBack.setOnClickListener(view -> { finish(); });


    }

    private boolean isExternalStorageReadable() {
        return Environment.getExternalStorageState().equals(Environment.MEDIA_MOUNTED) ||
                Environment.getExternalStorageState().equals(Environment.MEDIA_MOUNTED_READ_ONLY);
    }

    private void setTextViewContent() {

        int legacy = 0;
        String audioBooks = "No disponible";
        String documents = "No disponible";
        String screenshots = "No disponible";
        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.Q) {
            legacy = parseBoolean(Environment.isExternalStorageLegacy());
            audioBooks = Environment.DIRECTORY_AUDIOBOOKS;
            documents = Environment.DIRECTORY_DOCUMENTS;
            screenshots = Environment.DIRECTORY_SCREENSHOTS;
        }

        storageInfo.setText(
                String.format("State: %s\nEmulated: %d \nRemovable: %d \nLegacy: %d \nData Dir: %s \nCache Dir: %s \nExternal Storage Dir: %s \n" +
                        "External ALARMS Dir: %s \nExternal AUDIOBOOKS Dir: %s \nExternal DCIM Dir: %s \nExternal DOCUMENTS Dir: %s \n" +
                        "External DOWNLOADS Dir: %s \nExternal MOVIES Dir: %s \nExternal MUSIC Dir: %s \nExternal NOTIFICATIONS Dir: %s \n" +
                        "External PICTURES Dir: %s \nExternal PODCASTS Dir: %s \nExternal RINGTONES Dir: %s \nExternal SCREENSHOTS Dir: %s \n"
                        , Environment.MEDIA_MOUNTED, parseBoolean(Environment.isExternalStorageEmulated()),
                        parseBoolean(Environment.isExternalStorageRemovable()), legacy, Environment.getDataDirectory(), Environment.getDownloadCacheDirectory(),
                        Environment.getExternalStorageDirectory(), Environment.DIRECTORY_ALARMS, audioBooks, Environment.DIRECTORY_DCIM,
                        documents, Environment.DIRECTORY_DOWNLOADS, Environment.DIRECTORY_MOVIES, Environment.DIRECTORY_MUSIC,
                        Environment.DIRECTORY_NOTIFICATIONS, Environment.DIRECTORY_PICTURES, Environment.DIRECTORY_PODCASTS,
                        Environment.DIRECTORY_RINGTONES, screenshots
                ));
    }

    private int parseBoolean(boolean value) {
        return value ? 1 : 0;
    }


}