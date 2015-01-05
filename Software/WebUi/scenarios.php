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

//$db->SetDebug();

function GetScenarios()
{
	global $db;
	$scenarios	= $db->GetAll('select * from scenario left join interfaces on scenario.scenario_interface_id = interfaces.interface_id;');
	return($scenarios);
}

function GetInterfaces2()
{
	global $db;
	$interfaces	= $db->GetAll('SELECT * FROM interfaces i, devices d
						WHERE i.interface_deviceid=d.device_id
						AND interface_deleted=0 
						AND device_id>0 AND device_deleted=0 AND device_disabled=0
						ORDER BY interface_id ASC');

	return($interfaces);
}

// obs³uga POST 
if (isset($_POST['ScenarioID']))	{

	$scenario['id'] = $_POST['ScenarioID'];
	$scenario['name'] = $_POST['ScenarioName'];
	$scenario['order'] = $db->GetOne("SELECT MAX( scenario_order ) FROM scenario") + 1;
	$scenario['interface_id'] = $_POST['output_SourceID'];
	$scenario['interface_func'] = $_POST['output_state'];
	$scenario['func'] = $_POST['scenario_logic'];

	// Przekonwertuj pozosta³e dane _POST do postaci strawnej
	foreach ($_POST as $key => $value) {
		if (substr($key, 0, 5) =="input") {
			$elements = explode("_", $key);
			$scenario['elements'][$elements[1]][$elements[2]] = $value;
		}
	}
	
	foreach ($scenario['elements'] as $key => $value) {
		if ($value['SourceID'] == "clock") { // to jest zegar
			$scenario['elements'][$key]['value'] = $value['hour'] * 3600 + $value['min'] * 60 + $value['sec'];
		}
		if ($value['SourceID'] == "days") { // to jest kalendarz
			$scenario['elements'][$key]['value'] = $value['nd'] + $value['pn'] * 2 + $value['wt'] * 4 + $value['sr'] * 8 + $value['cz'] * 16 + $value['pt'] * 32 + $value['so'] * 64;
			
		}
		if (!isset($scenario['elements'][$key]['direction'])) $scenario['elements'][$key]['direction'] = 0;
	}
	//var_dump($scenario);
	
	// zak³adaj¹c ¿e jest wszystko ok... robimy inserty (lub update)
	if ($scenario_id == "new") {
		// insert
		$db->Execute("INSERT INTO scenario(scenario_name, scenario_order, scenario_interface_id, scenario_interface_func, scenario_func)  VALUES (?,?,?,?,?)",array($scenario['name'],$scenario['order'],$scenario['interface_id'],$scenario['interface_func'],$scenario['func']));
		$scenario_id = $db->GetOne('SELECT MAX(scenario_id) FROM scenario');
	} else {
		// update
		$db->Execute("UPDATE scenario SET scenario_name=?, scenario_interface_id=?, scenario_interface_func=?, scenario_func=? WHERE scenario_id=?",array($scenario['name'],$scenario['interface_id'],$scenario['interface_func'],$scenario['id']));
	}
	// teraz wykasujmy wszystkie elementy z id scenariusza (a potem siê je doda na nowo)
	$db->Execute("delete from scenario_items where scenario_items_scenario_id = ?",array($scenario['id']));
	// i wsadzamy elementy
	foreach ($scenario['elements'] as $key => $value) {
		$db->Execute("INSERT INTO  scenario_items (scenario_items_scenario_id, scenario_items_interface_id, scenario_items_interface_func, scenario_items_interface_val)  VALUES (?,?,?,?)",array($scenario['id'],$value['SourceID'],$value['direction'],$value['value']));
	}	

}

$interfaces	= GetInterfaces2();
$scenarios = GetScenarios();

$smarty->assign('interfaces',   $interfaces);
$smarty->assign('scenarios',   $scenarios);

if (isset($_GET['id']))	{
	$smarty->assign('id',   $_GET['id']);
	$smarty->display('scenario.tpl');
} else {
	$smarty->display('scenarios.tpl');
}

 ?>