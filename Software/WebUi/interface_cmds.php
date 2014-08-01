<?php

include("init.php");

$interface_id	= $_GET['interface_id'];
$action		= $_GET['action'];
$cmd    = "interface:".$interface_id.":".$action;

IPC_Command($cmd);

$ref=getenv("HTTP_REFERER");

header('Location: '.$ref);

?>