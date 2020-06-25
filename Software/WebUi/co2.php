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
	if($_GET['op'] == 'sets') {
		$db->Execute('UPDATE settings SET setting_value=?  where setting_key= ?', array($_POST['PHPROBE'],'co2_probe'));	
		$db->Execute('UPDATE settings SET setting_value=?  where setting_key= ?', array($_POST['CO2EN'],'co2_co2valve'));
		$db->Execute('UPDATE settings SET setting_value=?  where setting_key= ?', array($_POST['CO2PH'],'co2_co2limit'));
		$db->Execute('UPDATE settings SET setting_value=?  where setting_key= ?', array($_POST['O2EN'],'co2_o2valve'));
		$db->Execute('UPDATE settings SET setting_value=?  where setting_key= ?', array($_POST['O2PH'],'co2_o2limit'));
		$db->Execute('UPDATE settings SET setting_value=?  where setting_key= ?', array($_POST['hysteresis'],'co2_hysteresis'));		
	
		ReloadDaemonConfig();
		$SESSION->redirect("co2.php"); //przekierowanie w celu odswierzenia zmiennej $CONFIG inicjalizowanej przed wykonaniem update
	}	
}

$daemon_data 	= @simplexml_load_string(IPC_CommandWithReply("status"));
$interfaces = GetInterfaces();

$smarty->assign('daemon_data', $daemon_data);
$smarty->assign('interfaces', $interfaces);
$smarty->assign('title', 'Konfiguracja CO<sub>2</sub>');
$smarty->display('co2.tpl');
?>

