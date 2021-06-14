package com.mastermoviles.persistencia.files;

import android.graphics.Color;
import android.os.Bundle;
import android.util.Log;
import android.widget.Button;
import android.widget.TextView;

import androidx.appcompat.app.AppCompatActivity;

import java.io.BufferedReader;
import java.io.InputStreamReader;

public class FileActivity extends AppCompatActivity {

    private TextView fileContent;
    private Button goBack;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_file);

        fileContent = findViewById(R.id.fileContentTextView);
        goBack = findViewById(R.id.goMain);
        goBack.setOnClickListener(view -> { finish(); });
        this.readFile();
    }

    private void readFile() {
        try {
            BufferedReader fin = new BufferedReader(new InputStreamReader(openFileInput("practica_ficheros.txt")));
            String line = fin.readLine();
            while(line != null) {
                fileContent.append(line + "\n");
                line = fin.readLine();
            }
            fin.close();
        }
        catch (Exception ex) {
            Log.e("Files", "Error: " + ex.getMessage());
            fileContent.setTextColor(Color.RED);
            fileContent.setText("Se ha producido un error al leer el fichero.");
            if (ex.getMessage().contains("ENOENT")) {
                fileContent.setText("No se ha escrito nada en el fichero que se quiere leer.");
            }
        }
    }
}