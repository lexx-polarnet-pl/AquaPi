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

$dane   = '';
$stats	= $db->GetAll('SELECT stat_date as E, stat_value as N
                      FROM stats
                      WHERE stat_date >= ? AND stat_interfaceid=? ORDER BY stat_date ',
                      array($_GET['limit'], $_GET['interfaceid']));

if($_GET['simplify_graphs']==1)
    $stats  = RamerDouglasPeucker($stats, 0.1);

if(isset($stats))
foreach ($stats as $stat)
{
    $dane .= '[' . $stat['E'] . '000,' . $stat['N'] . '],';
}

$callback = (string)$_GET['callback'];

echo "$callback([".$dane."]);";

?>