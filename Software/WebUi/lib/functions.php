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
						WHERE i.interface_deviceid=d.device_id
						AND interface_deleted=0 AND interface_disabled=0
						AND device_id>0 AND device_deleted=0 AND device_disabled=0
						ORDER BY interface_address ASC');
	
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

function Read1Wire($address)
{
	if(!file_exists(ONEWIRE_DIR. $address. '/' . 'w1_slave'))
	    return FALSE;
	$lines  = file(ONEWIRE_DIR. $address. '/' . 'w1_slave');
	if (preg_match('/YES/', $lines[0]))
	{
		$temp   = explode('=', $lines[1]);
		$temp   = round($temp[1]/1000, 2);
		return $temp;
	}
	else
		return FALSE;	
}

function SaveLog($level, $message)
{
	global $db;
	$db->Execute('INSERT INTO logs (log_date, log_level, log_value)
                            VALUES (?NOW?, ?, ?)', array($level, $message));
}


//Finds the perpendicular distance from a point to a straight line.
//The coordinates of the point are specified as $ptX and $ptY.
//The line passes through points l1 and l2, specified respectively with their
//coordinates $l1x and $l1y, and $l2x and $l2y
function perpendicularDistance($ptX, $ptY, $l1x, $l1y, $l2x, $l2y)
{
    $result = 0;
    if ($l2x == $l1x)
    {
        //vertical lines - treat this case specially to avoid divide by zero
        $result = abs($ptX - $l2x);
    }
    else
    {
        $slope = (($l2y-$l1y) / ($l2x-$l1x));
        $passThroughY = (0-$l1x)*$slope + $l1y;
        $result = (abs(($slope * $ptX) - $ptY + $passThroughY)) / (sqrt($slope*$slope + 1));
    }
    return $result;
}

//Reduces the number of points on a polyline by removing those that are closer to the line
//than the distance $epsilon.
//The polyline is provided as an array of arrays, where each internal array is one point on the polyline,
//specified by easting (x-coordinate) with key "E" and northing (y-coordinate) with key "N".
//It is assumed that the coordinates and distance $epsilon are given in the same units.
//The result is returned as an array in a similar format.
//Each point returned in the result array will retain all its original data, including its E and N
//values along with any others.
function RamerDouglasPeucker($pointList, $epsilon)
{
    // Find the point with the maximum distance
    $dmax = 0;
    $index = 0;
    $totalPoints = count($pointList);
    for ($i = 1; $i < ($totalPoints - 1); $i++)
    {
        $d = perpendicularDistance($pointList[$i]["E"], $pointList[$i]["N"],
                                   $pointList[0]["E"], $pointList[0]["N"],
                                   $pointList[$totalPoints-1]["E"], $pointList[$totalPoints-1]["N"]);
			   
        if ($d > $dmax)
        {
            $index = $i;
            $dmax = $d;
        }
    }

    $resultList = array();
	
    // If max distance is greater than epsilon, recursively simplify
    if ($dmax >= $epsilon)
    {
        // Recursive call
        $recResults1 = RamerDouglasPeucker(array_slice($pointList, 0, $index + 1), $epsilon);
        $recResults2 = RamerDouglasPeucker(array_slice($pointList, $index, $totalPoints - $index), $epsilon);

        // Build the result list
        $resultList = array_merge(array_slice($recResults1, 0, count($recResults1) - 1),
                                  array_slice($recResults2, 0, count($recResults2)));
    }
    else
    {
        $resultList = array($pointList[0], $pointList[$totalPoints-1]);
    }
    // Return the result
    return $resultList;
}

function AddTimer($timer)
{
	global $db;
	//new dBug($timer);
	//czasowy
	if($timer['type']==1)
	{
		$db->Execute('INSERT INTO timers
					(timer_type,
					timer_timeif,
					timer_direction,
					timer_action,
					timer_interfaceidthen,
					timer_days )
				VALUES (?,?,?,?,?,?)',
				array(
					$timer['type'],
					$timer['timeif'],
					$timer['direction'],
					$timer['action'],
					$timer['interfaceidthen'],
					$timer['days'],
				));
	}
	elseif($timer['type']==2)
	{
		$db->Execute('INSERT INTO timers
					(timer_type,
					timer_interfaceidif,
					timer_direction,
					timer_value,
					timer_action,
					timer_interfaceidthen,
					timer_days )
				VALUES (?,?,?,?,?,?,?)',
				array(
					$timer['type'],
					$timer['interfaceidif'],
					$timer['direction'],
					$timer['value'],
					$timer['action'],
					$timer['interfaceidthen'],
					$timer['days'],
				));
	}
}

function TimeToUnixTime($time)
{
	$pieces = explode(":", $time);
	return intval($pieces[0])*60*60 + intval($pieces[1]*60) + intval($pieces[2]);
}

?>