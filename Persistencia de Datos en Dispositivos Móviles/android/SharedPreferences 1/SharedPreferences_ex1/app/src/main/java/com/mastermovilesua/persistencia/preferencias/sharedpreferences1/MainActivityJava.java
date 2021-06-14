package com.mastermovilesua.persistencia.preferencias.sharedpreferences1;

import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;

import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.SeekBar;
import android.widget.TextView;

import com.mastermovilesua.persistencia.preferencias.sharedpreferences1.Base64Java.*;


public class MainActivityJava extends AppCompatActivity implements View.OnClickListener {

    private EditText editText;
    private TextView seekBarText;
    private SeekBar seekBar;
    private Button applyChanges;
    private TextView resultsText;
    private Button goKotlin;
    private Button closeButton;
    private SharedPreferences preferences;
    private static final int ACTIVITY_RESULT_CODE = 1;



    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        this.preferences = getSharedPreferences("preferences", Context.MODE_PRIVATE);
        setTitle("SharedPreferences_ex1 (Java)");

        this.setUIContent();
        this.seekBar.setOnSeekBarChangeListener(new SeekBar.OnSeekBarChangeListener() {
            @Override
            public void onProgressChanged(SeekBar seekBar, int progress, boolean fromUser) {
                seekBarText.setText(String.format("Tamaño (%d/50)", progress));
            }

            @Override
            public void onStartTrackingTouch(SeekBar seekBar) {

            }

            @Override
            public void onStopTrackingTouch(SeekBar seekBar) {

            }
        });
        this.applyChanges.setOnClickListener(this);
        this.goKotlin.setOnClickListener(this);
        this.closeButton.setOnClickListener(this);
    }

    private void setUIContent() {
        this.editText = findViewById(R.id.editText);
        this.seekBarText = findViewById(R.id.seekSize);
        this.seekBar = findViewById(R.id.seekBar);
        this.applyChanges = findViewById(R.id.applyChanges);
        this.resultsText = findViewById(R.id.results);
        this.goKotlin = findViewById(R.id.changeVersion);
        this.goKotlin.setBackgroundResource(R.drawable.kotlin);
        this.closeButton = findViewById(R.id.close);

        String text = preferences.getString("text", "Hola Mundo!");
        this.editText.setText(Base64Cipher.decryptData(text));
    }

    private void setPreferencesData() {
        String encryptedText = Base64Cipher.encryptData(this.editText.getText().toString());
        String encryptedSize = Base64Cipher.encryptData(String.valueOf(this.seekBar.getProgress()));
        SharedPreferences.Editor editor = preferences.edit();
        editor.putString("text", encryptedText);
        editor.putString("size", encryptedSize);
        editor.apply();
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.applyChanges:
                this.setPreferencesData();
                Intent intent = new Intent(this, ActivitySecondJava.class);
                startActivityForResult(intent, ACTIVITY_RESULT_CODE);
                break;
            case R.id.changeVersion:
                Intent kotlinIntent = new Intent(this, MainActivity.class);
                startActivity(kotlinIntent);
            case R.id.close:
                this.finishAffinity();
        }
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, @Nullable Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (requestCode == ACTIVITY_RESULT_CODE && resultCode == RESULT_OK) {
            String text = preferences.getString("text", "Hola Mundo!");
            String size = preferences.getString("size", "32");
            resultsText.setText(String.format("Valores actuales de la aplicación:\n\nTexto: %s\nTamaño: %s",
                    Base64Cipher.decryptData(text), Base64Cipher.decryptData(size)));
        }
    }
}