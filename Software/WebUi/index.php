<?php

include("init.php");

$temp = $db->GetOne('select value from data where `key` = "temp_act";');
$heating = $db->GetOne('select value from data where `key` = "heating";') == "1";
$day = $db->GetOne('select value from data where `key` = "day";') == "1";
//var_dump($db->GetOne('select value from data where key = "heating";'));

$smarty->assign('time', date("H:i"));
$smarty->assign('temp', $temp);
$smarty->assign('heating', $heating);
$smarty->assign('day', $day);
$smarty->display('index.tpl');

?>

