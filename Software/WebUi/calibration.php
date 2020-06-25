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
	$records = 0;
	if($_GET['id']) {
		$records = $db->GetOne('SELECT COUNT(*) FROM calib_data WHERE `calib_data_interface_id` = ?',array($_GET['id']));
	}
	$smarty->assign('calibration_records', $records);
	
	if($_GET['action'] == 'edit') {
		$smarty->assign('edit', $_GET['id']);	
		// pobierz dane kalibracyjne z bazy, a jeśli ich nie ma, to przyjmij jakieś dane domyślne
		if ($records == 0) {
			// nie ma danych kalibracyjnych
			$smarty->assign('raw1', -100);
			$smarty->assign('cal1', -100);
			$smarty->assign('raw2', 100);
			$smarty->assign('cal2', 100);
		} else {
			// są dane kalibracyjne, pobierz je wyślij do przeglądarki
			$calib_data	= $db->GetRow('SELECT * FROM calib_data WHERE `calib_data_interface_id` = ?',array($_GET['id']));
			$smarty->assign('raw1', $calib_data['calib_data_raw1']);
			$smarty->assign('cal1', $calib_data['calib_data_cal1']);
			$smarty->assign('raw2', $calib_data['calib_data_raw2']);
			$smarty->assign('cal2', $calib_data['calib_data_cal2']);
		}		
	} elseif($_GET['action'] == 'delete') {
		// usuń dane kalibracyjne z bazy (o ile są)
		if ($records == 0) {
			// nie ma czego kasować
			$SESSION->redirect("calibration.php?action=edit&id=".$_GET['id']);
		} else {
			// jest co kasować, to wykonajmy query
			$db->Execute('DELETE FROM calib_data WHERE `calib_data_interface_id` = ?',array($_GET['id']));
			ReloadDaemonConfig();
			$SESSION->redirect("calibration.php?action=edit&id=".$_GET['id']);
		}
	} elseif($_GET['action'] == 'update') {
		if ($records == 0) {
			// nie ma jeszcze rekordów kalibracyjnych więc insert
			$db->Execute('INSERT INTO `calib_data` (`calib_data_interface_id`, `calib_data_raw1`, `calib_data_cal1`, `calib_data_raw2`, `calib_data_cal2`)
							VALUES (?,?,?,?,?)',array($_GET['id'],$_POST['raw1'],$_POST['cal1'],$_POST['raw2'],$_POST['cal2']));
		} else {
			// są dane kalibracyjne, więc update
			$db->Execute('UPDATE `calib_data` SET `calib_data_raw1` = ?, `calib_data_cal1`=?, `calib_data_raw2`=?, `calib_data_cal2`=? 
							WHERE `calib_data_interface_id`=?',array($_POST['raw1'],$_POST['cal1'],$_POST['raw2'],$_POST['cal2'],$_GET['id']));			
		}	
		ReloadDaemonConfig();
		$SESSION->redirect("calibration.php?action=edit&id=".$_GET['id']);
	}

$daemon_data 	= @simplexml_load_string(IPC_CommandWithReply("status"));
$interfaces = GetInterfaces();

$smarty->assign('daemon_data', $daemon_data);
$smarty->assign('interfaces', $interfaces);
$smarty->assign('title', 'Kalibracja czujników wejściowych');
$smarty->display('calibration.tpl');
?>

