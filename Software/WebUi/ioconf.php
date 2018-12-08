<?php
/*
 * AquaPi - sterownik akwariowy oparty o Raspberry Pi
 *
 * Copyright (C) 2012-2017 AquaPi Developers
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
$smarty->assign('title', 'Konfiguracja wejść/wyjść');

if($_POST) {
	//new dBug($_POST,'',true);die;
	foreach ($_POST['interfaces'] as $key => $interface) {
		$db->Execute('UPDATE interfaces SET interface_name = ?, interface_icon = ?, interface_htmlcolor = ? WHERE interface_id=?', array($interface['name'],$interface['img'],substr($interface['htmlcolor'],1),$key));
			//var_dump($interface);
	}
	ReloadDaemonConfig();
}
// dodawanie i kasowanie urządzeń
if(array_key_exists('action', $_GET))
{
	if ($_GET['action'] == "delete" and $_GET['device_id']>0)
	{
		$db->Execute('UPDATE interfaces SET interface_deleted=1 WHERE interface_id=?', array($_GET['device_id']));
		ReloadDaemonConfig();
		$SESSION->redirect("ioconf.php");
	}
	elseif($_GET['action'] == "add")
	{
		$input_address = $_POST['InputAddressSelector'];
		if ($_POST['FullyEditable']) {
			$input_address = $input_address.$_POST['FullyEditable'];
		}
		$db->Execute('INSERT INTO interfaces(interface_id, interface_address, interface_name, interface_type, interface_icon)
				     VALUES (?, ?, ?, ?, ?)',
				     array(0, $input_address, $_POST['InputFriendlyName'], $_POST["InputModeSelector"], $_POST['InputIconSelector']));
		ReloadDaemonConfig();
		//$SESSION->redirect("ioconf.php");
	}	
}

$icons 		= scandir('img/devices');
foreach($icons as $icon)
{
	if($icon === '.' or $icon === '..')
			{continue;}
	$result[] = $icon;
}
$icons	= $result;

// niech daemon powie jakie urządzena widzi
$device_list 	= @simplexml_load_string(IPC_CommandWithReply("devicelist"));

foreach ($device_list->devicelist->device as $value) {
	// sprawdź teraz czy te urządzenia nie są już skonfigurowane
	if (($db->GetOne("SELECT interface_id FROM interfaces WHERE interface_address ='?' AND interface_deleted <> 1",array($value->address)) > 0) && ($value->fully_editable_address !='yes')) {
		$value->addChild('configured', 'yes');

	}
}

$interfaces = GetInterfaces();

$smarty->assign('icons', 		$icons);
$smarty->assign('device_list',	$device_list);
$smarty->assign('devices',	$interfaces);

if ($device_list == false) {
	$smarty->display('daemon_missing.tpl');
} else {
	$smarty->display('ioconf.tpl');
};
?>

