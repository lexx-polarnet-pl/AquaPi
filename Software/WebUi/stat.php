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

$smarty->assign('title', 'Statystyki');

switch ($_GET['limit']) {
    case 'week':
		$limit = time() - (7 * 24 * 60 * 60);
        break;
    case 'month':
		$limit = time() - (31 * 24 * 60 * 60);
        break;
    case 'no_limit':
		$limit = 0;
        break;
    default:
		$limit = time() - (24 * 60 * 60);
}

$stat = $db->GetAll('select time_st,temp,sensor_id from temp_stats where time_st >= '.$limit.' and temp>-50 order by time_st;');

$first = $db->GetOne('select time_st from temp_stats where time_st >= '.$limit.' and temp>-50 order by time_st asc limit 1;');
$last = $db->GetOne('select time_st from temp_stats where time_st >= '.$limit.' and temp>-50 order by time_st desc limit 1;');
//echo $first." ".$last;
//var_dump($stat);

foreach ($stat as $value) {
    //var_dump($value['time_st']);
	$temp_arr[floor($value['time_st']/60)*60][$value['sensor_id']] = $value['temp'];
}

$out_names = $db->GetAll('select distinct(event) from output_stats where time_st >= '.$limit.' order by time_st;');
$stat = $db->GetAll('select time_st,state,event from output_stats where time_st >= '.$limit.' order by time_st;');

$i = 0;
foreach ($out_names as $name) {
    //var_dump($value['time_st']);
	//var_dump($name);
	$outputs_names[$name['event']]['id'] = $i;
	$outputs_names[$name['event']]['prev'] = null;
	$i++;
}

$i = 0;
foreach ($outputs_names as $key => $out_name) {
	$ini_val = $db->GetOne('select state from output_stats where time_st < '.$limit.' and event = "'.$key.'" order by time_st desc limit 1;');
	if ($ini_val == null) {$ini_val = 0; }
	$outputs_names[$key]['prev'] = $ini_val;
	$outputs_arr[$first][$i] = $ini_val;
	$i++;
}

foreach ($stat as $value) {
    //var_dump($value['time_st']);
	if ($outputs_names[$value['event']]['prev'] != $value['state']) {
		$outputs_arr[$value['time_st']-1][$outputs_names[$value['event']]['id']] = $outputs_names[$value['event']]['prev'];
	}
	$outputs_arr[$value['time_st']][$outputs_names[$value['event']]['id']] = $value['state'];
	$outputs_names[$value['event']]['prev'] = $value['state'];
}

$i = 0;
foreach ($outputs_names as $key => $out_name) {
	$outputs_arr[$last][$i] = $out_name['prev'];
	$i++;
}

//echo "<pre>";
//var_dump($outputs_names);
//var_dump($outputs_arr);
$smarty->assign('stat', $temp_arr);
$smarty->assign('outputs_arr', $outputs_arr);
$smarty->assign('outputs_names', $outputs_names);
$smarty->display('stat.tpl');
?>
