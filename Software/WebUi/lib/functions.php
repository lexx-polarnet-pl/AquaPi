<?php
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
						AND interface_deleted=0 
						AND device_id>0 AND device_deleted=0 AND device_disabled=0
						ORDER BY interface_id ASC');
	
	foreach($interfaces as $index => $interface)
	{
		$addressshort				= explode(':', $interface['interface_address']);
		if(isset($addressshort[2]))
		{
		    $interface['interface_addressshort']	= $addressshort[2];
		    $interface['interface_addressshortnext']	= $addressshort[2]+1;
		}
		
		$interface['interface_unit']=$db->GetRow('SELECT unit_id, unit_name
							 FROM unitassignments, units
							 WHERE unit_id = unitassignment_unitid AND unitassignment_interfaceid=?', array($interface['interface_id']));
		
		$tmp[$interface['device_name']][]=$interface;
	}
	return($tmp);
}

function GetNotes()
{
	global $db;
	$notes	= $db->GetAll('SELECT * FROM notes n
					WHERE note_deleted=0
					ORDER BY note_id ASC');
	
	return($notes);
}

function AddNote($note)
{
	global $db;
	$db->Execute('INSERT INTO notes
				(note_title,
				 note_content)
			VALUES (?,?)',
			array(
				$note['title'],
				$note['content'],
			));
}

function DeleteNote($note)
{
	global $db;
	$db->Execute('UPDATE notes SET note_deleted=1 WHERE note_id=?',
			array(
				$note['id'],
			));
}

function GetInterfaceUnits()
{
	global $db;
	$interfaces	= $db->GetAll('SELECT interface_id FROM interfaces i
						WHERE interface_deleted=0 
						ORDER BY interface_address ASC');
	
	foreach($interfaces as $index => $interface)
	{
	    $tmp[$interface['interface_id']]	= $db->GetRow('SELECT unit_id, unit_name
							FROM unitassignments, units
							WHERE unit_id = unitassignment_unitid AND unitassignment_interfaceid=?', array($interface['interface_id']));
	}
	return($tmp);
}

function GetInterfacesIcons()
{
	global $db;
	$interfaces	= $db->GetAll('SELECT interface_id,interface_icon FROM interfaces WHERE interface_type=2');
	
	foreach($interfaces as $index => $interface)
	{
		$tmp[$interface['interface_id']]	= $interface['interface_icon'];
	}
	return($tmp);
}

function GetMasterInterfaceId()
{
	global $db;
	return $db->GetOne('SELECT interface_id FROM interfaces i, devices d
				WHERE i.interface_deviceid=d.device_id
				AND interface_deleted=0 
				AND device_id>0 AND device_deleted=0 AND device_disabled=0 
				AND interface_conf=? AND device_name=?
				ORDER BY interface_address ASC', array(1, '1wire'));
	

}

function GetDevices()
{
	global $db;
	return $db->GetAll('SELECT * FROM devices
				WHERE device_id>0 AND device_deleted=0');
}

function GetUnits()
{
	global $db;
	return $db->GetAll('SELECT * FROM units');
}


function GetDeviceId($name)
{
	global $db;
	return $db->GetOne('SELECT device_id FROM devices
				WHERE device_name=?', array($name));
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
	if($timer['type']==1 or $timer['type']==3)
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
	elseif($timer['type']==2  or $timer['type']==4)
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

function xml2array($contents, $get_attributes=1, $priority = 'tag')
{
    if(!$contents) return array();

    if(!function_exists('xml_parser_create')) {
        //print "'xml_parser_create()' function not found!";
        return array();
    }

    //Get the XML parser of PHP - PHP must have this module for the parser to work
    $parser = xml_parser_create('');
    xml_parser_set_option($parser, XML_OPTION_TARGET_ENCODING, "UTF-8"); # http://minutillo.com/steve/weblog/2004/6/17/php-xml-and-character-encodings-a-tale-of-sadness-rage-and-data-loss
    xml_parser_set_option($parser, XML_OPTION_CASE_FOLDING, 0);
    xml_parser_set_option($parser, XML_OPTION_SKIP_WHITE, 1);
    xml_parse_into_struct($parser, trim($contents), $xml_values);
    xml_parser_free($parser);

    if(!$xml_values) return;//Hmm...

    //Initializations
    $xml_array = array();
    $parents = array();
    $opened_tags = array();
    $arr = array();

    $current = &$xml_array; //Refference

    //Go through the tags.
    $repeated_tag_index = array();//Multiple tags with same name will be turned into an array
    foreach($xml_values as $data) 
    {
        unset($attributes,$value);//Remove existing values, or there will be trouble

        //This command will extract these variables into the foreach scope
        // tag(string), type(string), level(int), attributes(array).
        extract($data);//We could use the array by itself, but this cooler.

        $result = array();
        $attributes_data = array();
        
        if(isset($value)) {
            if($priority == 'tag') $result = $value;
            else $result['value'] = $value; //Put the value in a assoc array if we are in the 'Attribute' mode
        }

        //Set the attributes too.
        if(isset($attributes) and $get_attributes) {
            foreach($attributes as $attr => $val) {
                if($priority == 'tag') $attributes_data[$attr] = $val;
                else $result['attr'][$attr] = $val; //Set all the attributes in a array called 'attr'
            }
        }

        //See tag status and do the needed.
        if($type == "open") {//The starting of the tag '<tag>'
            $parent[$level-1] = &$current;
            if(!is_array($current) or (!in_array($tag, array_keys($current)))) { //Insert New tag
                $current[$tag] = $result;
                if($attributes_data) $current[$tag. '_attr'] = $attributes_data;
                $repeated_tag_index[$tag.'_'.$level] = 1;

                $current = &$current[$tag];

            } else { //There was another element with the same tag name

                if(isset($current[$tag][0])) {//If there is a 0th element it is already an array
                    $current[$tag][$repeated_tag_index[$tag.'_'.$level]] = $result;
                    $repeated_tag_index[$tag.'_'.$level]++;
                } else {//This section will make the value an array if multiple tags with the same name appear together
                    $current[$tag] = array($current[$tag],$result);//This will combine the existing item and the new item together to make an array
                    $repeated_tag_index[$tag.'_'.$level] = 2;
                    
                    if(isset($current[$tag.'_attr'])) { //The attribute of the last(0th) tag must be moved as well
                        $current[$tag]['0_attr'] = $current[$tag.'_attr'];
                        unset($current[$tag.'_attr']);
                    }

                }
                $last_item_index = $repeated_tag_index[$tag.'_'.$level]-1;
                $current = &$current[$tag][$last_item_index];
            }
        } elseif($type == "complete") { //Tags that ends in 1 line '<tag />'
            //See if the key is already taken.

        if(strpos($tag, ":")>0)
            $tag=substr($tag, strpos($tag, ":")+1);


            if(!isset($current[$tag])) { //New Key
                $current[$tag] = $result;
                $repeated_tag_index[$tag.'_'.$level] = 1;
                if($priority == 'tag' and $attributes_data) $current[$tag. '_attr'] = $attributes_data;

            } else { //If taken, put all things inside a list(array)
                if(isset($current[$tag][0]) and is_array($current[$tag])) {//If it is already an array...
                    // ...push the new element into that array.
                    $current[$tag][$repeated_tag_index[$tag.'_'.$level]] = $result;
                    
                    if($priority == 'tag' and $get_attributes and $attributes_data) {
                        $current[$tag][$repeated_tag_index[$tag.'_'.$level] . '_attr'] = $attributes_data;
                    }
                    $repeated_tag_index[$tag.'_'.$level]++;

                } else { //If it is not an array...
                    $current[$tag] = array($current[$tag],$result); //...Make it an array using using the existing value and the new value
                    $repeated_tag_index[$tag.'_'.$level] = 1;
                    if($priority == 'tag' and $get_attributes) {
                        if(isset($current[$tag.'_attr'])) { //The attribute of the last(0th) tag must be moved as well
                            
                            $current[$tag]['0_attr'] = $current[$tag.'_attr'];
                            unset($current[$tag.'_attr']);
                        }
                        
                        if($attributes_data) {
                            $current[$tag][$repeated_tag_index[$tag.'_'.$level] . '_attr'] = $attributes_data;
                        }
                    }
                    $repeated_tag_index[$tag.'_'.$level]++; //0 and 1 index is already taken
                }
            }

        } elseif($type == 'close') { //End of tag '</tag>'
            $current = &$parent[$level-1];
        }
    }
    
    return($xml_array);
}

?>