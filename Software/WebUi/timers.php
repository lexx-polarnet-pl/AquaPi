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

$smarty->assign('title', 'Timery');

if ($_GET['op'] == 'add_new') {
	//var_dump($_POST);
	$pieces = explode(":", $_POST['ev_start']);
	$ev_start = intval($pieces[0])*60*60 + intval($pieces[1]*60) + intval($pieces[2]);
	$pieces = explode(":", $_POST['ev_stop']);
	$ev_stop = intval($pieces[0])*60*60 + intval($pieces[1]*60) + intval($pieces[2]);	
	$days_of_week = $_POST['d1'] +$_POST['d2'] +$_POST['d3'] +$_POST['d4'] +$_POST['d5'] +$_POST['d6'] +$_POST['d7'];
	$device= $_POST['device'];
	$query = "INSERT INTO timers (t_start,t_stop,device,day_of_week) VALUES ($ev_start,$ev_stop,'$device',$days_of_week);";
	$db->Execute($query);
	//echo $query;
}

if ($_GET['op'] == 'del') {
	//var_dump($_POST);
	$id = $_GET['id'];
	$query = "DELETE FROM timers WHERE Id = $id;";
	$db->Execute($query);
	//echo $query;
}

//$line_5 = $db->GetOne("select value from settings where `key`='gpio5_name';");
//$line_6 = $db->GetOne("select value from settings where `key`='gpio6_name';");
$friendly_names = $db->GetAll('select device,fname,output from devices where output <> "disabled" and device like "uni%";');
$timers = $db->GetAll(' select timers.*,devices.fname from timers left join devices on timers.device = devices.device;');
//var_dump($timers);
$smarty->assign('timers', $timers);
//$smarty->assign('line_5', $line_5);
$smarty->assign('friendly_names', $friendly_names);

date_default_timezone_set('UTC');
$smarty->display('timers.tpl');
?>
