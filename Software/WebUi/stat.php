<?php
/*
 * AquaPi - sterownik akwariowy oparty o Raspberry Pi
 *
 * Copyright (C) 2012 Marcin Król (lexx@polarnet.pl)
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
 * $Id:$
 */
 
include("init.php");

$smarty->assign('title', 'Statystyki');

switch ($_GET['limit']) {
    case 'week':
		$limit = time() - (7 * 24 * 60 * 60);
        break;
    case 'month':
		$limit = time() - (31 * 7 * 24 * 60 * 60);
        break;
    case 'no_limit':
		$limit = 0;
        break;
    default:
		$limit = time() - (24 * 60 * 60);
}

//if(isset($_GET['limit']))$limit = $_GET['limit'];

$stat = $db->GetAll('select * from stat where time_st >= '.$limit.';');
$smarty->assign('stat', $stat);
$smarty->display('stat.tpl');
?>
