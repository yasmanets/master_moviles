package es.ua.eps.chat;

import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.graphics.Color;
import android.os.Bundle;
import android.os.Handler;
import android.util.Log;
import android.view.View;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.TextView;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.net.InetAddress;
import java.net.ServerSocket;
import java.net.Socket;
import java.net.UnknownHostException;
import java.util.ArrayList;

public class ChatActivity extends AppCompatActivity implements View.OnClickListener {

    private String name;
    private String ipDestiny;
    private ServerSocket serverSocket;
    private Thread serverThread = null;
    private Thread thread = null;
    private Client clientThread = null;
    private Socket clientSocket;
    private ListView messagesList;
    private Handler handler;
    private ArrayList<TextView> messages = new ArrayList<>();
    public static final int SERVER_PORT = 4200;

    private Button sendButton;
    private EditText editMessage;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_chat);

        getIntentValues();
        initVariables();
        initChat();
    }

    private void initVariables() {
        handler = new Handler();
        ArrayAdapter<TextView> messagesAdapter = new ArrayAdapter<>(this, android.R.layout.simple_list_item_1, messages);
        messagesList = findViewById(R.id.messagesList);
        messagesList.setAdapter(messagesAdapter);
        sendButton = findViewById(R.id.send);
        editMessage = findViewById(R.id.message);
        sendButton.setOnClickListener(this);
    }

    private void getIntentValues() {
        Intent intent = getIntent();
        name = intent.getStringExtra("nickname");
        ipDestiny = intent.getStringExtra("ipDestiny");
    }

    private void initChat() {
        serverThread = new Thread(new Server());
        serverThread.start();
        clientThread = new Client();
        thread = new Thread(clientThread);
        thread.start();
        Log.d("Chat", "Init chat");
        return;
    }

    private void showMessage(String message, int color) {
        handler.post(() -> {
            messages.add(setTextView(message, color));
        });
    }

    public TextView setTextView(String message, int color) {
        if (message == null || message.trim().isEmpty()) {
            message = getText(R.string.emptyMessage).toString();
        }
        TextView messageTextView = new TextView(this);
        messageTextView.setTextColor(color);
        messageTextView.setText(name + ": " + message);
        messageTextView.setTextSize(20);
        messageTextView.setPadding(0, 5,0,0);
        return messageTextView;
    }

    private void sendMessage(String message) {
        try {
            if (clientSocket != null) {
                new Thread(new Runnable() {
                    @Override
                    public void run() {
                        PrintWriter output = null;
                        try {
                            output = new PrintWriter(new BufferedWriter(
                                    new OutputStreamWriter(clientSocket.getOutputStream())),
                                    true);
                        } catch (IOException e) {
                            e.printStackTrace();
                        }
                        output.println(message);
                    }
                });
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void onClick(View v) {
        String message = editMessage.getText().toString().trim();
        showMessage(message, Color.BLACK);
        if (clientThread != null) {
            clientThread.sendMessage(message);
        }
    }

    class Server implements Runnable {

        @Override
        public void run() {
            Socket socket;
            try {
                serverSocket = new ServerSocket(SERVER_PORT);
            } catch (IOException e) {
                e.printStackTrace();
            }
            if (serverSocket != null) {
                while (!Thread.currentThread().isInterrupted()) {
                    try {
                        socket = serverSocket.accept();
                        Communication communication = new Communication(socket);
                        new Thread(communication).start();
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                }
            }
        }
    }

    class Client implements Runnable {
        private Socket socket;
        private BufferedReader input;

        @Override
        public void run() {
            try {
                InetAddress serverAddress = InetAddress.getByName(ipDestiny);
                socket = new Socket(serverAddress, SERVER_PORT);

                while (!Thread.currentThread().isInterrupted()) {
                    this.input = new BufferedReader(new InputStreamReader(socket.getInputStream()));
                    String message = input.readLine();
                    if (message == null || "Disconnect".contentEquals(message)) {
                        Thread.interrupted();
                        message = getText(R.string.serverDisconnected).toString();
                        break;
                    }
                    //showMessage
                }

            } catch (UnknownHostException e) {
                e.printStackTrace();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }

        void sendMessage(String message) {
            new Thread(() -> {
                try {
                    if (socket != null) {
                        PrintWriter output = new PrintWriter(new BufferedWriter(
                                new OutputStreamWriter(socket.getOutputStream())), true);
                        output.println(message);
                    }
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }).start();
        }
    }

    class Communication implements Runnable {

        private Socket client;
        private BufferedReader inputBuffer;

        public Communication(Socket tmpClientSocket) {
            this.client = tmpClientSocket;
            clientSocket = tmpClientSocket;
            try {
                this.inputBuffer = new BufferedReader(new InputStreamReader(this.client.getInputStream()));
            } catch (IOException e) {
                e.printStackTrace();
            }
        }

        @Override
        public void run() {
            while (!Thread.currentThread().isInterrupted()) {
                try {
                    String line = inputBuffer.readLine();
                    if (line == null || "Disconnect".contentEquals(line)) {
                        Thread.interrupted();
                        line = getText(R.string.clientDisconnected).toString();
                        break;
                    }
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }

        }
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        if (null != serverThread) {
            // sendMessage
            serverThread.interrupt();
            serverThread = null;
        }
    }
}

