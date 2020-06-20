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
if($_GET['op'] == 'test') {
	$smarty->assign('email_test', true);
	IPC_Command('testemail');
}
if($_POST) {
	if($_GET['op'] == 'update') {
		$db->Execute('UPDATE settings SET setting_value=?  where setting_key= ?', array($_POST['email'],'email_address'));	
		ReloadDaemonConfig();
		$SESSION->redirect("notifications.php"); //przekierowanie w celu odswierzenia zmiennej $CONFIG inicjalizowanej przed wykonaniem update
	}
}
$daemon_data 	= @simplexml_load_string(IPC_CommandWithReply("status"));
$smarty->assign('daemon_data', $daemon_data);
$smarty->assign('title', 'Powiadomienia');
$smarty->display('notifications.tpl');
?>

