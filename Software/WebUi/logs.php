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

// przywróć ustawienia filtrowania
$SESSION -> restore('log_filter',$log_filter);
if ($log_filter ==  NULL) $log_filter = "all";

// zobacz czy trzeba na nowo ustawić filtry
if(array_key_exists('filter', $_GET)) {
	$log_filter = $_GET['filter'];
	$SESSION -> save('log_filter',$log_filter);
}

// zapisz kiedy ostatni raz były przeczytane komunikaty błędów
$db->Execute('UPDATE settings SET setting_value=?  where setting_key= ?', array(time(),'log_read_time'));

// wykasuj logi starsze niż 30 dni
$period = $CONFIG['webui']['purge_logs'] * 24 * 60 * 60; //30 dni
$db->Execute('DELETE FROM logs WHERE log_date<?', array(time() - $period));

// ustaw zmienną do filtrowania
if ($log_filter=="warn") {
	$log_filter_lev = 1;
} elseif ($log_filter=="crit") {
	$log_filter_lev = 2;
} else {
	$log_filter_lev = 0;
}

// ile na stronę
$count  = 25;
// która strona
$start  = 0;
$curr_page = 1;

// sprawdź ile jest rekordów w totalu
$r = $db->GetOne('select count(*) from logs WHERE log_level >=?', array($log_filter_lev));

if(isset($_GET['offset']))
{
    $start = $count * $_GET['offset'];
	$curr_page = $_GET['offset'] + 1;
}

$end    = $start + $count;
$pages  = ceil($r/$count);

// pobierz logi
$logs   = $db->GetAll('SELECT * FROM logs WHERE log_level >=? ORDER BY log_date DESC LIMIT ?, ? ', array($log_filter_lev, $start, $end));

$smarty->assign('title', 'Zdarzenia systemowe');
$smarty->assign('logs', $logs);
$smarty->assign('pages', $pages);
$smarty->assign('curr_page', $curr_page);
$smarty->assign('page_total', $end);
$smarty->assign('count', $count);
$smarty->assign('log_filter', $log_filter);
$smarty->display('logs.tpl');
?>
