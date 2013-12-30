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
 * $Id$
 */
 
include("init.php");

// spróbuj wyłapać najświeższy wynik przyjmując limit 15 min. Jak nie ma, takiego to znaczy że nie rejestrujemy.
// $limit jest na razie nie brany pod uwage! Trzeba później dopisać!
//$limit 		= time() - (15 * 60);
$limit48h 	= time() - (60 * 60 * 48);


$interfaces	= GetInterfaces();
if (!is_null($interfaces['1wire'])) 
{
	foreach($interfaces['1wire'] as $index => $sensor)
	{
		$interfaces['1wire'][$index]['interface_temperature']=$db->GetRow('SELECT * FROM stats_view WHERE stat_interfaceid=? ORDER BY stat_date DESC LIMIT 0,1', array($sensor['interface_id']));
		if($sensor['interface_conf']==1)
		{
			$sensor_master_temp = $interfaces['1wire'][$index]['interface_temperature']['stat_value'];
		}
	}
}

foreach($interfaces['gpio'] as $index => $gpio)
{
	//foreach($CONFIG as $index2 => $config)
	//	if($index2 == $gpio['interface_address'])
	//		$interfaces['gpio'][$index]['interface_icon']=$config;
	$interfaces['gpio'][$index]['interface_state']=$db->GetRow('SELECT * FROM stats_view WHERE stat_interfaceid=? ORDER BY stat_date DESC LIMIT 0,1', array($gpio['interface_id']));
}

foreach($interfaces['relayboard'] as $index => $relay)
{
	//foreach($CONFIG as $index2 => $config)
	//	if($index2 == $relay['interface_address'])
	//		$interfaces['relayboard'][$index]['interface_icon']=$config;
	$interfaces['relayboard'][$index]['interface_state']=$db->GetRow('SELECT * FROM stats_view WHERE stat_interfaceid=? ORDER BY stat_date DESC LIMIT 0,1', array($relay['interface_id']));
}

foreach($interfaces['dummy'] as $index => $sensor)
{
	$interfaces['dummy'][$index]['interface_temperature']=$db->GetRow('SELECT * FROM stats_view WHERE stat_interfaceid=? ORDER BY stat_date DESC LIMIT 0,1', array($sensor['interface_id']));
}
//
//new dBug($interfaces	, "", true);
//new dBug($CONFIG, "", true);


$last5infologs 	= $db->GetAll('select * from logs where log_level = 0 AND log_date > ? order by log_date desc limit 0,5;', array($limit48h));
$last5warnlogs 	= $db->GetAll('select * from logs where log_level > 0 AND log_date > ? order by log_date desc limit 0,5;', array($limit48h));

$uptime 	= exec("cat /proc/uptime | awk '{ print $1 }'");
$enabled 	= date("d.m.Y H:i",time() - $uptime);
$uname_r 	= php_uname("r");
$uname_v 	= php_uname("v");
$load 		= sys_getloadavg();
$cputemp	= exec("cat /sys/class/thermal/thermal_zone0/temp")/1000;
$daemon_data = @simplexml_load_string(IPC_CommandWithReply("status"));

$smarty->assign('enabled', $enabled);
$smarty->assign('time', date("H:i"));
$smarty->assign('interfaces', $interfaces);
$smarty->assign('sensor_master_temp', $sensor_master_temp);
$smarty->assign('uname_r', $uname_r);
$smarty->assign('uname_v', $uname_v);
$smarty->assign('load', $load);
$smarty->assign('cputemp', $cputemp);
$smarty->assign('daemon_data', $daemon_data);
$smarty->assign('last5infologs', $last5infologs);
$smarty->assign('last5warnlogs', $last5warnlogs);
//$smarty->assign('devices', $devices);
$smarty->display('index.tpl');
//echo"<pre>";
//var_dump($daemon_data);
?>

