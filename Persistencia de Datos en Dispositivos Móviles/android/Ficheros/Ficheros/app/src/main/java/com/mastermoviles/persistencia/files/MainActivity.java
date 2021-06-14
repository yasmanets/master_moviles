package com.mastermoviles.persistencia.files;

import androidx.appcompat.app.AppCompatActivity;

import android.content.Context;
import android.content.Intent;
import android.os.Build;
import android.os.Bundle;
import android.os.Environment;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.OutputStreamWriter;

public class MainActivity extends AppCompatActivity implements View.OnClickListener {

    private Button externalState;
    private EditText editText;
    private Button addToFile;
    private Button showFile;
    private Button moveExternal;
    private Button moveInternal;
    private Button finishApp;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        this.setUIContent();
    }

    private void setUIContent() {
        externalState = findViewById(R.id.externalState);
        editText = findViewById(R.id.editText);
        addToFile = findViewById(R.id.addToFile);
        showFile = findViewById(R.id.showFile);
        moveExternal = findViewById(R.id.moveExternal);
        moveInternal = findViewById(R.id.moveInternal);
        finishApp = findViewById(R.id.finish);

        externalState.setOnClickListener(this);
        addToFile.setOnClickListener(this);
        showFile.setOnClickListener(this);
        moveExternal.setOnClickListener(this);
        moveInternal.setOnClickListener(this);
        finishApp.setOnClickListener(this);
    }

    @Override
    public void onClick(View view) {
        switch (view.getId()) {
            case R.id.externalState:
                Intent intent = new Intent(this, ExternalActivity.class);
                startActivity(intent);
                break;
            case R.id.addToFile:
                this.saveDataToFile();
                break;
            case R.id.showFile:
                Intent showFileIntent = new Intent(this, FileActivity.class);
                startActivity(showFileIntent);
                break;
            case R.id.moveExternal:
                this.moveToExternal();
                break;
            case R.id.moveInternal:
                this.moveToInternal();
                break;
            case R.id.finish:
                finish();
                break;
            default:
                Log.d("Main", "no existe el botón");
        }
    }

    private void saveDataToFile() {
        String text = editText.getText().toString();
        try {
            OutputStreamWriter fout = new OutputStreamWriter(openFileOutput("practica_ficheros.txt", Context.MODE_APPEND));
            fout.append(text + "\n");
            fout.close();
            Toast.makeText(this, "Texto guardado con éxito", Toast.LENGTH_LONG).show();
            editText.setText("");
        }
        catch (Exception ex) {
            Log.e("Files", String.format("Error: %s", ex.getMessage()));
        }
    }

    private void moveToExternal() {
        if (checkSDCardStatus()) {
            File path = null;
            if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.KITKAT) {
                path = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOCUMENTS);
            }
            else {
                path = new File(Environment.getExternalStorageDirectory().getAbsolutePath());
            }
            File file = new File(path, "practica_ficheros.txt");
            try {
                path.mkdirs();
                InputStream inputStream = openFileInput("practica_ficheros.txt");
                OutputStream outputStream = new FileOutputStream(file);
                byte [] data = new byte[inputStream.available()];
                inputStream.read(data);
                outputStream.write(data);
                inputStream.close();
                outputStream.close();
                Toast.makeText(this, "Se ha movido el fichero a la memoria externa", Toast.LENGTH_LONG).show();
            }
            catch (IOException ex) {
                Log.w("ExternalStorage", "Error writting: " + file, ex);
                String message = "Se ha producido un error al escribir en la memoria SD";
                if (ex.getMessage().contains("ENOENT")) {
                    message = "No existe el fichero que se quiere mover.";
                }
                Toast.makeText(this, message, Toast.LENGTH_LONG).show();
            }
        }
        else {
            Toast.makeText(this, "No se puede acceder a la memoroia SD", Toast.LENGTH_LONG).show();
        }
    }

    private void moveToInternal() {
        if (checkSDCardStatus()) {
            File sdPath = null;
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
                sdPath = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOCUMENTS);
            }
            else {
                sdPath = new File(Environment.getExternalStorageDirectory().getAbsolutePath());
            }
            File file = new File(sdPath, "practica_ficheros.txt");

            try {
                InputStream inputStream = new FileInputStream(file);
                OutputStream outputStream = openFileOutput("practica_ficheros.txt", Context.MODE_PRIVATE);
                byte [] data = new byte[inputStream.available()];
                inputStream.read(data);
                outputStream.write(data);
                inputStream.close();
                outputStream.close();
                Toast.makeText(this, "Se ha movido el fichero a la memoria interna", Toast.LENGTH_LONG).show();
            }
            catch (IOException ex) {
                Log.w("ExternalStorage", "Error writting: " + file, ex);
                String message = "Se ha producido un error al escribir en la memoria interna";
                if (ex.getMessage().contains("ENOENT")) {
                    message = "No existe el fichero que se quiere mover.";
                }
                Toast.makeText(this, message, Toast.LENGTH_LONG).show();
            }
        }
        else {
            Toast.makeText(this, "No se puede acceder a la memoroia SD", Toast.LENGTH_LONG).show();
        }
    }

    private boolean checkSDCardStatus() {
        if (Environment.getExternalStorageState().equals(Environment.MEDIA_MOUNTED)) {
            return true;
        }
        else if (Environment.getExternalStorageState().equals(Environment.MEDIA_MOUNTED_READ_ONLY)) {
            return false;
        }
        else {
            return false;
        }
    }
}