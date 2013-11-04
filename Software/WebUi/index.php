<?php
/*
 * AquaPi - sterownik akwariowy oparty o Raspberry Pi
 *
 * Copyright (C) 2012 Marcin Król (lexx@polarnet.pl)
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

// spróbuj wyłapać najświerzszy wynik przyjmując limit 15 min. Jak nie ma, takiego to znaczy że nie rejestrujemy.
$limit = time() - (15 * 60);
$temp1 = $db->GetOne('select temp from temp_stats where sensor_id = 1 and time_st > '.$limit.' order by time_st desc limit 1;');
$temp2 = $db->GetOne('select temp from temp_stats where sensor_id = 2 and time_st > '.$limit.' order by time_st desc limit 1;');
$temp3 = $db->GetOne('select temp from temp_stats where sensor_id = 3 and time_st > '.$limit.' order by time_st desc limit 1;');
$temp4 = $db->GetOne('select temp from temp_stats where sensor_id = 4 and time_st > '.$limit.' order by time_st desc limit 1;');


$last5infologs = $db->GetAll('select * from log where level = 0 order by time desc limit 5;');
$last5warnlogs = $db->GetAll('select * from log where level <> 0 order by time desc limit 5;');

$devices = $db->GetAll('select * from devices where output <> "disabled";');

foreach ($devices as $key => $device) {
	$devices[$key]['output_state']= $db->GetOne('select state from output_stats where `event` = "'.$device['device'].'" order by time_st desc limit 1;');
}

$uptime = exec("cat /proc/uptime | awk '{ print $1 }'");
$enabled = date("d.m.Y H:i",time() - $uptime);
$uname_r = php_uname("r");
$uname_v = php_uname("v");
$load = sys_getloadavg();

$smarty->assign('enabled', $enabled);
$smarty->assign('time', date("H:i"));
$smarty->assign('temp1', $temp1);
$smarty->assign('temp2', $temp2);
$smarty->assign('temp3', $temp3);
$smarty->assign('temp4', $temp4);
$smarty->assign('uname_r', $uname_r);
$smarty->assign('uname_v', $uname_v);
$smarty->assign('load', $load);
$smarty->assign('last5infologs', $last5infologs);
$smarty->assign('last5warnlogs', $last5warnlogs);
$smarty->assign('devices', $devices);
$smarty->display('index.tpl');
?>

