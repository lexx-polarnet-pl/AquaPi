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

$smarty->assign('title', 'Dashboard');

$sysinfo	= xml2array(IPC_CommandWithReply("sysinfo"));
$uptime 	= exec("cat /proc/uptime | awk '{ print $1 }'");
$enabled 	= date("d.m.Y H:i",time() - $sysinfo['aquapi']['sysinfo']['uptime']);
$daemon_data 	= @simplexml_load_string(IPC_CommandWithReply("status"));
$status 	= @xml2array(IPC_CommandWithReply("status"));
$icons		= GetInterfacesIcons();
$interfaceunits	= GetInterfaceUnits();

$smarty->assign('sysinfo', 		$sysinfo);
$smarty->assign('enabled', 		$enabled);
$smarty->assign('time', 		date("H:i"));
$smarty->assign('interfaceunits', 	$interfaceunits);
$smarty->assign('daemon_data', 		$daemon_data);
$smarty->assign('status', 		$status);
$smarty->assign('icons', 		$icons);

$smarty->display('index.tpl');

?>

