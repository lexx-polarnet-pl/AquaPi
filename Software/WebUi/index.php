<?php
/*
 * AquaPi - sterownik akwariowy oparty o Raspberry Pi
 *
 * Copyright (C) 2012-2013 AquaPi Developers
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License Version 2 as
 * published by the Free Software Foundation.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307,
 * USA.
 *
 * $Id:$
 */
 
include("init.php");

// spróbuj wyłapać najświeższy wynik przyjmując limit 15 min. Jak nie ma, takiego to znaczy że nie rejestrujemy.
$limit 		= time() - (15 * 60);
$limit48h 	= time() - (60 * 60 * 48);

$sensor_ids	= $db->GetAll('SELECT DISTINCT sensor_id AS id
				FROM temp_stats WHERE time_st >= ? AND temp > -50 AND sensor_id >0 ORDER BY time_st', array($limit));

if ($sensor_ids) 
{
	foreach($sensor_ids as $index => $sensor)
		$temperatures[]	= $db->GetRow('SELECT s.*,temp as sensor_temp
						FROM temp_stats ts, sensors s
						WHERE s.sensor_id=ts.sensor_id AND s.sensor_deleted=0 AND ts.sensor_id = ? and time_st > ? order by time_st desc limit 0,1', array($sensor['id'], $limit));
	$temperatures	= array_values(array_filter($temperatures));
}
//new dBug($temperatures);

$last5infologs 	= $db->GetAll('select * from log where level = 0  AND time > ? order by time desc limit 0,5;', array($limit48h));
$last5warnlogs 	= $db->GetAll('select * from log where level <> 0 AND time > ? order by time desc limit 0,5;', array($limit48h));

$devices 	= $db->GetAll('select * from devices where output <> ? ', array("disabled"));

foreach ($devices as $key => $device) 
{
	$devices[$key]['output_state']= $db->GetOne('select state from output_stats where `event` = ? order by time_st desc limit 0,1', array($device['device']));
}

$uptime 	= exec("cat /proc/uptime | awk '{ print $1 }'");
$enabled 	= date("d.m.Y H:i",time() - $uptime);
$uname_r 	= php_uname("r");
$uname_v 	= php_uname("v");
$load 		= sys_getloadavg();
$cputemp	= exec("cat /sys/class/thermal/thermal_zone0/temp")/1000;

$smarty->assign('enabled', $enabled);
$smarty->assign('time', date("H:i"));
$smarty->assign('temperatures', $temperatures);
$smarty->assign('uname_r', $uname_r);
$smarty->assign('uname_v', $uname_v);
$smarty->assign('load', $load);
$smarty->assign('cputemp', $cputemp);
$smarty->assign('last5infologs', $last5infologs);
$smarty->assign('last5warnlogs', $last5warnlogs);
$smarty->assign('devices', $devices);
$smarty->display('index.tpl');
?>

