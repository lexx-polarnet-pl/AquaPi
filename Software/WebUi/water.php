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

// kasowanie rekordu
if (@$_GET['action'] == 'delete') {
	$waterid = $_GET['waterid'];
	$db->Execute("DELETE FROM water WHERE water_id = ?", array($waterid));
	$SESSION->redirect('water.php');
}
if (@$_GET['action'] == 'add') {
	$timestamp = strtotime($_POST['date']);
	if ($_POST['ph'] != "") { $ph = floatval($_POST['ph']); } else { $ph = null; }
	if ($_POST['gh'] != "") { $gh = floatval($_POST['gh']); } else { $gh = null; }
	if ($_POST['kh'] != "") { $kh = floatval($_POST['kh']); } else { $kh = null; }
	if ($_POST['no2'] != "") { $no2 = floatval($_POST['no2']); } else { $no2 = null; }
	if ($_POST['no3'] != "") { $no3 = floatval($_POST['no3']); } else { $no3 = null; }
	if ($_POST['cl2'] != "") { $cl2 = floatval($_POST['cl2']); } else { $cl2 = null; }
	$db->Execute("INSERT INTO water (water_date, water_ph, water_gh, water_kh, water_no2, water_no3, water_cl2, water_comment) VALUES (?, ?, ?, ?, ?, ?, ?, ?)",
		array($timestamp,$ph,$gh,$kh,$no2,$no3,$cl2,$_POST['comment']));
	$SESSION->redirect('water.php');
}
//aktualizacja konfiguracji
//if($_POST) {
//	$db->Execute('UPDATE settings SET setting_value=?  where setting_key= ?', array(str_replace(array("C","°"),"",$_POST['TMAX']),'temp_tmax'));
//	$db->Execute('UPDATE settings SET setting_value=?  where setting_key= ?', array(str_replace(array("C","°"),"",$_POST['HC']),'temp_hc'));
//	$db->Execute('UPDATE settings SET setting_value=?  where setting_key= ?', array(str_replace(array("C","°"),"",$_POST['TMIN']),'temp_tmin'));
//	$db->Execute('UPDATE settings SET setting_value=?  where setting_key= ?', array(str_replace(array("C","°"),"",$_POST['HG']),'temp_hg'));
//	$db->Execute('UPDATE settings SET setting_value=?  where setting_key= ?', array(str_replace(array("C","°"),"",$_POST['NCOR']),'temp_ncor'));
//	$db->Execute('UPDATE settings SET setting_value=?  where setting_key= ?', array(str_replace(array("C","°"),"",$_POST['TMAXAL']),'temp_tmaxal'));
//	$db->Execute('UPDATE settings SET setting_value=?  where setting_key= ?', array(str_replace(array("C","°"),"",$_POST['TMINAL']),'temp_tminal'));
//	$db->Execute('UPDATE settings SET setting_value=?  where setting_key= ?', array($_POST['face_heat'],'temp_interface_heat'));
//	$db->Execute('UPDATE settings SET setting_value=?  where setting_key= ?', array($_POST['interface_cool'],'temp_interface_cool'));
//	$db->Execute('UPDATE settings SET setting_value=?  where setting_key= ?', array($_POST['interface_sensor'],'temp_interface_sensor'));
//	
//	ReloadDaemonConfig();
//	$SESSION->redirect("temp.php"); //przekierowanie w celu odswierzenia zmiennej $CONFIG inicjalizowanej przed wykonaniem update
//}

$smarty->assign('title', 'Parametry wody');

if (@$_GET['action'] == 'addnew') {
	$smarty->display('water_add.tpl');
} else {
	$water = $db->GetAll("select * from water order by water_date desc");
	$smarty->assign('water',  $water);

	$smarty->display('water.tpl');
}
?>

