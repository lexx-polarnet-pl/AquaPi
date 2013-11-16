<?


function array_msort($array, $cols)
{
    $colarr = array();
    foreach ($cols as $col => $order) {
	$colarr[$col] = array();
	foreach ($array as $k => $row) { $colarr[$col]['_'.$k] = strtolower($row[$col]); }
    }
    $eval = 'array_multisort(';
    foreach ($cols as $col => $order) {
	$eval .= '$colarr[\''.$col.'\'],'.$order.',';
    }
    $eval = substr($eval,0,-1).');';
    eval($eval);
    $ret = array();
    foreach ($colarr as $col => $arr) {
	foreach ($arr as $k => $v) {
	    $k = substr($k,1);
	    if (!isset($ret[$k])) $ret[$k] = $array[$k];
	    $ret[$k][$col] = $array[$k][$col];
	}
    }
    return $ret;

}

function ReloadDaemonConfig()
{
	IPC_Command("reload");
}



function Progress($current, $total, $header, $footer) 
{
	echo "<span style='position: absolute;z-index:$current;background:#FFF;'>&nbsp;".$current." | ". $total." | ". $header." | ". $footer."</span>";
	myFlush();
}

function myFlush() 
{
	echo(str_repeat(' ', 256));
	if (@ob_get_contents()) 
	{
		@ob_end_flush();
	}
	flush();
}

?>