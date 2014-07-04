<?php

include("../../init.php");

//new dbug($_GET);

if($_GET['is_sure']=="1")
	$db->Execute("UPDATE calendar_occurrences SET done=1 WHERE oid = ?", array($_GET['oid']));

$SESSION->redirect('../../index.php');

?>