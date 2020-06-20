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

if (@$_GET['action'] == 'add')
{
	$db->Execute('INSERT INTO alarms
				(alarm_interface_id,
				alarm_action_level,
				alarm_direction,
				alarm_text,
				alarm_level)
			VALUES (?,?,?,?,?)',
			array(
				$_POST['alarm_interface_id'],
				$_POST['alarm_action_level'],
				$_POST['alarm_direction'],
				$_POST['alarm_text'],
				$_POST['alarm_level']
			));
	ReloadDaemonConfig();
	$SESSION->redirect('alerts.php');
}
if (@$_GET['action'] == 'delete')
{
	$alarmid = $_GET['alarmid'];
	$db->Execute("DELETE FROM alarms WHERE alarm_id = ?", array($alarmid));
	ReloadDaemonConfig();
	$SESSION->redirect('alerts.php');
}

$interfaces         = GetInterfaces();
$alarms			    = $db->GetAll('SELECT *,	
								(SELECT interface_name FROM interfaces WHERE interface_id=alarm_interface_id) as alarm_interfacethenname,
								(SELECT interface_icon FROM interfaces WHERE interface_id=alarm_interface_id) as alarm_interfacethenicon	 
								FROM alarms ORDER BY alarm_interface_id');

$smarty->assign('alarms', $alarms);
$smarty->assign('interfaces', $interfaces);

$smarty->assign('title', 'Konfiguracja alertów');
$smarty->display('alerts.tpl');
?>

