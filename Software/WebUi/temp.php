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
//aktualizacja konfiguracji
if($_POST) {
	$db->Execute('UPDATE settings SET setting_value=?  where setting_key= ?', array(str_replace(array("C","°"),"",$_POST['TMAX']),'temp_tmax'));
	$db->Execute('UPDATE settings SET setting_value=?  where setting_key= ?', array(str_replace(array("C","°"),"",$_POST['HC']),'temp_hc'));
	$db->Execute('UPDATE settings SET setting_value=?  where setting_key= ?', array(str_replace(array("C","°"),"",$_POST['TMIN']),'temp_tmin'));
	$db->Execute('UPDATE settings SET setting_value=?  where setting_key= ?', array(str_replace(array("C","°"),"",$_POST['HG']),'temp_hg'));
	$db->Execute('UPDATE settings SET setting_value=?  where setting_key= ?', array(str_replace(array("C","°"),"",$_POST['NCOR']),'temp_ncor'));
	$db->Execute('UPDATE settings SET setting_value=?  where setting_key= ?', array(str_replace(array("C","°"),"",$_POST['TMAXAL']),'temp_tmaxal'));
	$db->Execute('UPDATE settings SET setting_value=?  where setting_key= ?', array(str_replace(array("C","°"),"",$_POST['TMINAL']),'temp_tminal'));
	$db->Execute('UPDATE settings SET setting_value=?  where setting_key= ?', array($_POST['interface_heat'],'temp_interface_heat'));
	$db->Execute('UPDATE settings SET setting_value=?  where setting_key= ?', array($_POST['interface_cool'],'temp_interface_cool'));
	$db->Execute('UPDATE settings SET setting_value=?  where setting_key= ?', array($_POST['interface_sensor'],'temp_interface_sensor'));
	
	ReloadDaemonConfig();
	$SESSION->redirect("temp.php"); //przekierowanie w celu odswierzenia zmiennej $CONFIG inicjalizowanej przed wykonaniem update
}

$interfaces = GetInterfaces();

$smarty->assign('title', 'Konfiguracja temperatury');
$smarty->assign('interfaces', $interfaces);

$smarty->display('temp.tpl');
?>

