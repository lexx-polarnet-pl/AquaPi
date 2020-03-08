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
	$db->Execute("UPDATE settings SET setting_value=?  where setting_key = 'service_mode_input'", array($_POST['service_mode_input']));
	
	ReloadDaemonConfig();
	$SESSION->redirect("service.php"); //przekierowanie w celu odswierzenia zmiennej $CONFIG inicjalizowanej przed wykonaniem update
}

$interfaces = GetInterfaces();

$smarty->assign('title', 'Konfiguracja ustawień serwisowych');
$smarty->assign('interfaces', $interfaces);

$smarty->display('service.tpl');
?>

