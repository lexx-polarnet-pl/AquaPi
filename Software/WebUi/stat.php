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
	case 'month':
	    $limit = time() - (31 * 24 * 60 * 60);
	    break;
	case 'week':
	    $limit = time() - (7 * 24 * 60 * 60);
	    break;
	case 'no_limit':
	    $limit = 0;
	    break;
	default:
	    $limit = time() - (7 * 24 * 60 * 60); //7 days
    }
else
    $limit = time() - (7 * 24 * 60 * 60);

//aktywne interfejsy    
$draw_t	= array('1wire', 'system');
$draw_p	= array('gpio', 'relayboard');

//new dBug(GetInterfaces());
foreach(GetInterfaces() as $type => $sensors_tmp)
    foreach($sensors_tmp as $sensor)
    {
	if (in_array($type, $draw_t) and $sensor['interface_draw']==1)
	    $sensors['temps'][]	= $sensor;
	if (in_array($type, $draw_p) and $sensor['interface_draw']==1)
	    $sensors['ports'][]	= $sensor;
    }
//new dBug($sensors);
$smarty->assign('sensors', $sensors);
$smarty->assign('simplify_graphs', $CONFIG['simplify_graphs']);
$smarty->assign('limit', $limit);
$smarty->display('stat.tpl');
?>
