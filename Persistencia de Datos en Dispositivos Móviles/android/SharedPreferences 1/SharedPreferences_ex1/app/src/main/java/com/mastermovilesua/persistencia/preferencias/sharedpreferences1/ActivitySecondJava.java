package com.mastermovilesua.persistencia.preferencias.sharedpreferences1;

import androidx.appcompat.app.AppCompatActivity;

import android.content.Context;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.view.Gravity;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;

import com.mastermovilesua.persistencia.preferencias.sharedpreferences1.Base64Java.Base64Cipher;

public class ActivitySecondJava extends AppCompatActivity implements View.OnClickListener {

    private TextView textView;
    private Button backButton;
    private SharedPreferences preferences;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_second);
        preferences = getSharedPreferences("preferences", Context.MODE_PRIVATE);
        setTitle("SP_1 Detail (Java)");

        this.setUIContent();
        this.getPreferencesData();
        this.backButton.setOnClickListener(this);
    }

    private void setUIContent() {
        this.textView = findViewById(R.id.secondViewTextView);
        this.backButton = findViewById(R.id.buttonBack);
    }

    private void getPreferencesData() {
        String text = preferences.getString("text", "Hola Mundo!");
        String size = preferences.getString("size", "32");
        this.textView.setText(Base64Cipher.decryptData(text));
        this.textView.setTextSize(Float.valueOf(Base64Cipher.decryptData(size)));
        this.textView.setGravity(Gravity.CENTER_HORIZONTAL);
    }

    @Override
    public void onClick(View v) {
        setResult(RESULT_OK);
        finish();
    }
}