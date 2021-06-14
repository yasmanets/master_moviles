package es.ua.eps.chat;

import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.net.wifi.WifiManager;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;
import android.text.format.Formatter;

public class MainActivity extends AppCompatActivity implements View.OnClickListener {

    private EditText nickname;
    private EditText ipDestiny;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        TextView host = findViewById(R.id.host);
        nickname = findViewById(R.id.nicknameEditText);
        ipDestiny = findViewById(R.id.ipEditText);
        Button startChat = findViewById(R.id.start);
        WifiManager wifiManager = (WifiManager) getApplicationContext().getSystemService(WIFI_SERVICE);
        int ipAddress = wifiManager.getConnectionInfo().getIpAddress();
        host.setText("HOST: " + Formatter.formatIpAddress(ipAddress));
        startChat.setOnClickListener(this);


    }

    @Override
    public void onClick(View v) {
        Intent intent = new Intent(v.getContext(), ChatActivity.class);
        intent.putExtra("nickname", nickname.getText().toString());
        intent.putExtra("ipDestiny", ipDestiny.getText().toString());
        startActivity(intent);
    }
}