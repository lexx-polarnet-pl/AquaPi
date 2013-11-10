<?

//new dBug($CONFIG['plugins']);
$relayboard = $db->GetAll('SELECT *, relay_type XOR relay_state as relay_enable FROM relayboard');
$smarty->assign('relayboard', $relayboard);

//new dBug($relayboard);

?>
