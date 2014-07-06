<?php

include("init.php");

$interface_id	= $_POST['interface_id'];
$action		= $_POST['action'];

$cmd    = "interface:".$interface_id.":".$action;

//$file = '/tmp/cmd';
//$fp = fopen($file, 'a');
//fwrite($fp, print_r($_POST, TRUE));
//fwrite($fp, $cmd);
//fclose($fp);

IPC_Command($cmd);
echo "Polecenie \"".$cmd."\" wysłane";

?>