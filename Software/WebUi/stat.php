<?php
/*
 * AquaPi - sterownik akwariowy oparty o Raspberry Pi
 *
 * Copyright (C) 2012-2014 AquaPi Developers
 *
 * This program is free software; you can redistribute it AND/or modify
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

$smarty->assign('title', 'Statystyki');


if(array_key_exists('limit', $_GET))
    switch ($_GET['limit'])
    {
	case 'year':
		    $limit = time() - (365 * 24 * 60 * 60);
	    break;
	case 'week':
		    $limit = time() - (7 * 24 * 60 * 60);
	    break;
	case 'month':
		    $limit = time() - (31 * 24 * 60 * 60);
	    break;
	case 'no_limit':
		    $limit = 0;
	    break;
	default:
		    $limit = time() - (24 * 60 * 60);
    }
else
    $limit = time() - (24 * 60 * 60);

//aktywne interfejsy    
//$wire	= $db->GetOne('SELECT GROUP_CONCAT(interface_id)
//		      FROM interfaces i, devices d
//		      WHERE interface_disabled =0 AND interface_deleted =0 AND i.interface_deviceid = d.device_id AND device_id >0 AND device_deleted =0 AND device_name =  "1wire"
//		      ORDER BY interface_id');
$sensors	= GetInterfaces();
$sensors	= $sensors['1wire'];
//$wire	= '1';
//new dBug($stat,"",true);
//new dBug($sensors);


$smarty->assign('sensors', $sensors);
$smarty->assign('simplify_graphs', $CONFIG['simplify_graphs']);
$smarty->assign('limit', $limit);
$smarty->display('stat.tpl');
?>
