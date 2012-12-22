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

$temp = $db->GetOne('select value from data where `key` = "temp_act";');
$heating = $db->GetOne('select value from data where `key` = "heating";') == "1";
$day = $db->GetOne('select value from data where `key` = "day";') == "1";
//var_dump($db->GetOne('select value from data where key = "heating";'));

$last5infologs = $db->GetAll('select * from log where level = 0 order by time desc limit 5;');
$last5warnlogs = $db->GetAll('select * from log where level <> 0 order by time desc limit 5;');

$smarty->assign('title', 'Strona główna');

$smarty->assign('time', date("H:i"));
$smarty->assign('temp', $temp);
$smarty->assign('heating', $heating);
$smarty->assign('day', $day);
$smarty->assign('last5infologs', $last5infologs);
$smarty->assign('last5warnlogs', $last5warnlogs);
$smarty->display('index.tpl');

?>

