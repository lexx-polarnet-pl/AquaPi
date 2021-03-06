<?php
/*
 * AquaPi - sterownik akwariowy oparty o Raspberry Pi
 *
 * Copyright (C) 2012-2020 AquaPi Developers
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

$smarty->assign('title', 'Timery');

if (@$_GET['action'] == 'add')
{
	$timer['timeif'] = TimeToUnixTime($_POST['timeif']);
	$timer['action'] = $_POST['action'];
	$timer['interfaceidthen'] = $_POST['interfaceidthen'];
	$timer['days'] = ($_POST['d1']?$_POST['d1']:'0') . ($_POST['d2']?$_POST['d2']:'0') . 
			 ($_POST['d3']?$_POST['d3']:'0') . ($_POST['d4']?$_POST['d4']:'0') .
			 ($_POST['d5']?$_POST['d5']:'0') . ($_POST['d6']?$_POST['d6']:'0') . 
			 ($_POST['d7']?$_POST['d7']:'0');

	AddTimer($timer);
	ReloadDaemonConfig();
	$SESSION->redirect('timers.php');
}

if (@$_GET['action'] == 'delete')
{
	$timerid = $_GET['timerid'];
	$db->Execute("DELETE FROM timers WHERE timer_id = ?", array($timerid));
	ReloadDaemonConfig();
	$SESSION->redirect('timers.php');
}

if (@$_GET['action'] == 'update')
{
	if($_POST) {
		foreach ($_POST['timers'] as $key => $timer) {
			$timeif = TimeToUnixTime($timer['timeif']);
			$days = ($timer['d1']?$timer['d1']:'0') . ($timer['d2']?$timer['d2']:'0') . 
			 ($timer['d3']?$timer['d3']:'0') . ($timer['d4']?$timer['d4']:'0') .
			 ($timer['d5']?$timer['d5']:'0') . ($timer['d6']?$timer['d6']:'0') . 
			 ($timer['d7']?$timer['d7']:'0');
			$db->Execute('UPDATE timers SET timer_timeif = ?, timer_action = ?, timer_days = ? WHERE timer_id=?', array($timeif,$timer['action'],$days,$key));
		}	
	}
	ReloadDaemonConfig();
	$SESSION->redirect('timers.php');	
}

$interfaces         = GetInterfaces();
$timers			    = $db->GetAll('SELECT *,
								(SELECT interface_name FROM interfaces WHERE interface_id=timer_interfaceidthen) as timer_interfacethenname,
								(SELECT interface_icon FROM interfaces WHERE interface_id=timer_interfaceidthen) as timer_interfacethenicon								
								FROM timers ORDER BY timer_interfaceidthen, timer_timeif');

$smarty->assign('timers', $timers);
$smarty->assign('interfaces', $interfaces);
$smarty->display('timers.tpl');

?>
