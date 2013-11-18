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

function GetInterfaces()
{
	global $db;
	$interfaces	= $db->GetAll('SELECT * FROM interfaces i, devices d
						WHERE interface_disabled=0 AND interface_deleted=0
						AND i.interface_deviceid=d.device_id
						AND device_id>0 AND device_deleted=0');
	
	foreach($interfaces as $index => $interface)
	{
		$addressshort=explode(':',$interface['interface_address']);
		$interface['interface_addressshort']=$addressshort[2];
		$interface['interface_addressshortnext']=$addressshort[2]+1;
		$tmp[$interface['device_name']][]=$interface;
	}
	return($tmp);
}

function GetDevices()
{
	global $db;
	return $db->GetAll('SELECT * FROM devices
				WHERE device_id>0 AND device_deleted=0');
}

?>