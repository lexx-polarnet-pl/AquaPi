<?php

include("init.php");

$logs = $db->GetAll('select * from log order by time desc;');

//var_dump($result);

$smarty->assign('time', date("H:i"));
$smarty->assign('temp', $temp);
$smarty->assign('heating', false);
$smarty->assign('day', false);
$smarty->assign('logs', $logs);
$smarty->display('logs.tpl');
?>
