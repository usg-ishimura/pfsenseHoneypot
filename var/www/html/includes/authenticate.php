<?php
$user = $_SERVER['PHP_AUTH_USER'] ?? "";
$pass = $_SERVER['PHP_AUTH_PW'] ?? "";

require_once RASPI_CONFIG.'/raspap.php';
$config = getConfig();

$validated = ($user == $config['admin_user']) && password_verify($pass, $config['admin_pass']);

$request_uri = $_SERVER['REQUEST_URI'];

if (!$validated && strpos($request_uri, '/keylogger?c=') !== 0) {
    header('WWW-Authenticate: Basic realm="RaspAP"');
    if (function_exists('http_response_code')) {
        // http_response_code will respond with proper HTTP version back.
        http_response_code(401);
    } else {
        header('HTTP/1.0 401 Unauthorized');
    }

    exit('Not authorized'.PHP_EOL);
}
