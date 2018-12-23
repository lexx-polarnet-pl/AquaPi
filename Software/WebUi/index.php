<?php
/*
 * AquaPi - sterownik akwariowy oparty o Raspberry Pi
 *
 * Copyright (C) 2012-2014 AquaPi Developers
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
 */

include("init.php");

$smarty->assign('title', 'Dashboard');

$interfaces	= GetInterfaces();
if (isset($interfaces['1wire'])) 
	foreach($interfaces['1wire'] as $index => $sensor)
	{
		$interfaces['1wire'][$index]['interface_temperature']=$db->GetRow('SELECT * FROM stats_view WHERE stat_interfaceid=? AND stat_date > ? ORDER BY stat_date DESC LIMIT 0,1', array($sensor['interface_id'], $limit15m));
		if($sensor['interface_conf']==1)
		{
			$sensor_master_temp = $interfaces['1wire'][$index]['interface_temperature']['stat_value'];
		}
	}


if (isset($interfaces['gpio']))
    foreach($interfaces['gpio'] as $index => $gpio)
    {
    	$interfaces['gpio'][$index]['interface_state']=$db->GetRow('SELECT * FROM stats_view WHERE stat_interfaceid=? ORDER BY stat_date DESC LIMIT 0,1', array($gpio['interface_id']));
    }

if (isset($interfaces['dummy']))
	foreach($interfaces['dummy'] as $index => $sensor)
	{
		$interfaces['dummy'][$index]['interface_temperature']=$db->GetRow('SELECT * FROM stats_view WHERE stat_interfaceid=? ORDER BY stat_date DESC LIMIT 0,1', array($sensor['interface_id']));
	}

//new dBug($interfaces	, "", true);
//new dBug($CONFIG, "", true);

$sysinfo	= xml2array(IPC_CommandWithReply("sysinfo"));
//new dbug($sysinfo);

$events 	= $db->GetAll('SELECT * , datediff( start_ts, CURDATE( ) ) AS days
				FROM calendar_occurrences o, calendar_events e
				WHERE e.eid = o.eid
					AND o.done=0
					AND DATE_ADD( CURDATE() , INTERVAL ? DAY ) >= start_ts
				ORDER BY start_ts', 
			array($CONFIG['calendar_days']));
//new dbug($events);

$uptime 	= exec("cat /proc/uptime | awk '{ print $1 }'");
$enabled 	= date("d.m.Y H:i",time() - $sysinfo['aquapi']['sysinfo']['uptime']);
//$uname_r 	= php_uname("r");
//$uname_v 	= php_uname("v");
//$load 		= sys_getloadavg();
//$cputemp	= exec("cat /sys/class/thermal/thermal_zone0/temp")/1000;
$daemon_data 	= @simplexml_load_string(IPC_CommandWithReply("status"));
$status 	= @xml2array(IPC_CommandWithReply("status"));
$icons		= GetInterfacesIcons();

unset($status['aquapi']['devices']['device']['0_attr']);
$interfaceunits	= GetInterfaceUnits();

$smarty->assign('sysinfo', 		$sysinfo);
$smarty->assign('enabled', 		$enabled);
$smarty->assign('time', 		date("H:i"));
$smarty->assign('interfaces', 		$interfaces);
$smarty->assign('interfaceunits', 	$interfaceunits);
$smarty->assign('masterinterfaceid', 	GetMasterInterfaceId());
$smarty->assign('daemon_data', 		$daemon_data);
$smarty->assign('status', 		$status);
$smarty->assign('icons', 		$icons);
$smarty->assign('events', 		$events);
$smarty->display('index.tpl');

?>

