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

$smarty->assign('title', 'Timery');
/*if($_POST)
{
    new dBug($_GET);
    new dBug($_POST);
    
}
else*/
if ($_GET['action'] == 'add')
{
    $timer['type']=$_POST['type'];
    $timer['direction']=$_POST['direction'];
    $pieces = explode(":", $_POST['timeif']);
    $timer['timeif'] = intval($pieces[0])*60*60 + intval($pieces[1]*60) + intval($pieces[2]);
    $timer['action'] = $_POST['action'];
    $timer['interfaceidthen'] = $_POST['interfaceidthen'];
    $timer['days'] = ($_POST['d1']?$_POST['d1']:'0') . ($_POST['d2']?$_POST['d2']:'0') . ($_POST['d3']?$_POST['d3']:'0') . ($_POST['d4']?$_POST['d4']:'0') .
                    ($_POST['d5']?$_POST['d5']:'0') . ($_POST['d6']?$_POST['d6']:'0') . ($_POST['d7']?$_POST['d7']:'0');
    $timer['interfaceidif'] = $_POST['interfaceidif'];
    $timer['value'] = $_POST['value'];
    AddTimer($timer);
    $SESSION->redirect('timers.php');
}

if ($_GET['action'] == 'delete')
{
    $timerid = $_GET['timerid'];
    $db->Execute("DELETE FROM timers WHERE timer_id = ?", array($timerid));
    //ReloadDaemonConfig();
}

$interfaces         = GetInterfaces();
$timers['time']     = $db->GetAll('SELECT *,
                                    (SELECT interface_name FROM interfaces WHERE interface_id=t.timer_interfaceidif) as timer_interfaceifname,
                                    (SELECT interface_name FROM interfaces WHERE interface_id=t.timer_interfaceidthen) as timer_interfacethenname
                                  FROM timers t
                                  WHERE timer_type=1');
$timers['1wire']    = $db->GetAll('SELECT *,
                                  (SELECT interface_name FROM interfaces WHERE interface_id=t.timer_interfaceidif) as timer_interfaceifname,
                                  (SELECT interface_name FROM interfaces WHERE interface_id=t.timer_interfaceidthen) as timer_interfacethenname
                                  FROM timers t
                                  WHERE timer_type=2');

//new dBug($timers);

$smarty->assign('timers', $timers);
$smarty->assign('interfaces', $interfaces);
//new dBug($interfaces,"",true);
$smarty->display('timers.tpl');
?>
