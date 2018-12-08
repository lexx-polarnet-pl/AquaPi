<?php
/*
 * AquaPi - sterownik akwariowy oparty o Raspberry Pi
 *
 * Copyright (C) 2012-2014 AquaPi Developers
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

// zapisz kiedy ostatni raz były przeczytane komunikaty błędów
$db->Execute('UPDATE settings SET setting_value=?  where setting_key= ?', array(time(),'log_read_time'));

$count  = 100;
$start  = 0;
$period = $CONFIG['webui']['purge_logs'] * 24 * 60 * 60; //30 dni
$db->Execute('DELETE FROM logs WHERE log_date<?', array(time() - $period));

if(isset($_GET['offset']))
{
    $start = $count * $_GET['offset'];
}

$end    = $start + $count;
$r      = $db->GetOne('select count(*) from logs;');
$pages  = ceil($r/$count);

$logs   = $db->GetAll('SELECT * FROM logs ORDER BY log_date DESC LIMIT ?, ?', array($start, $end));

$smarty->assign('title', 'Zdarzenia systemowe');
$smarty->assign('logs', $logs);
$smarty->assign('pages', $pages);
$smarty->display('logs.tpl');
?>
