<?php

// Put your device token here (without spaces):
$deviceToken = '3222b69f2aa549f45635ca5cc646d9c86249a6413082893ad60a38af73ca6b8d';


// Put your private key's passphrase here:
// $passphrase = '';

$message = $argv[1];

if (!$message )
    exit('Example Usage: $php apnspush.php \'Buenos días!!\'' . "\n");

////////////////////////////////////////////////////////////////////////////////

$ctx = stream_context_create([
            'ssl' => [
                'verify_peer'      => true,
                'verify_peer_name' => true,
                'cafile'           => 'entrust_2048_ca.cer',
            ]
        ]);
stream_context_set_option($ctx, 'ssl', 'local_cert', 'UADevelopmentPushCertificate.pem');
// stream_context_set_option($ctx, 'ssl', 'passphrase', $passphrase);

// Open a connection to the APNS server
$fp = stream_socket_client(
  'ssl://gateway.sandbox.push.apple.com:2195', $err,
  $errstr, 60, STREAM_CLIENT_CONNECT|STREAM_CLIENT_PERSISTENT, $ctx);

if (!$fp)
  exit("Failed to connect: $err $errstr" . PHP_EOL);

echo 'Connected to APNS' . PHP_EOL;

// Notificación visible

// $body['aps'] = array(
//  'alert' => $message,
//  'sound' => 'default',
//  );

    
// Notificación silenciosa

$body['aps'] = array(
  'content-available' => 1,
  'sound' => 'default',
  );
$body['mensaje'] = $message;

  
// Encode the payload as JSON
$payload = json_encode($body);

// Build the binary notification
$msg = chr(0) . pack('n', 32) . pack('H*', $deviceToken) . pack('n', strlen($payload)) . $payload;

// Send it to the server
$result = fwrite($fp, $msg, strlen($msg));

if (!$result)
  echo 'Message not delivered' . PHP_EOL;
else
  echo 'Message successfully delivered' . PHP_EOL;

// Close the connection to the server
fclose($fp);
