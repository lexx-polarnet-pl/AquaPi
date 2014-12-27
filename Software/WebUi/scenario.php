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
 
// Requires PHP 5.4 or higher


include("init.php");
$smarty->assign('title', 'Ustawienia');
/*
//kasowanie urzadzen i interfejsów
if(array_key_exists('action', $_GET))
{
	if ($_GET['action'] == "delete" and $_GET['device_id']>0 and $_GET['is_sure']==1)
	{
		$db->Execute('UPDATE devices SET device_deleted=1 WHERE device_id=?', array($_GET['device_id']));
		ReloadDaemonConfig();
		$SESSION->redirect("settings.php");
	}
	elseif($_GET['action'] == "delete" and $_GET['interface_id']>0 and $_GET['is_sure']==1)
	{
		$db->Execute('UPDATE interfaces SET interface_deleted=1 WHERE interface_id=?', array($_GET['interface_id']));
		ReloadDaemonConfig();
		$SESSION->redirect("settings.php");
	}
	elseif($_GET['action'] == "add_input")
	{
		$input_address = $_POST['InputAddressSelector'];
		if ($_POST['FullyEditable']) {
			$input_address = $input_address.":".$_POST['FullyEditable'];
		}
		$db->Execute('INSERT INTO interfaces(interface_id, interface_deviceid, interface_address, interface_name, interface_corr, interface_draw, interface_type, interface_icon)
				     VALUES (?, ?, ?, ?, ?, ?, ?, ?)',
				     array(0, 0, $input_address, $_POST['InputFriendlyName'], 0, 1, 1, $_POST['InputIconSelector']));
		$interface_id = $db->GetOne('select interface_id from interfaces where interface_address = ? order by interface_id desc limit 1;',array($input_address));
		if($_POST['InputUom'] != 'none')	{
			echo "tutaj";
			$db->Execute('INSERT INTO unitassignments(unitassignment_unitid, unitassignment_interfaceid) VALUES(?, ?)', array($_POST['InputUom'], $interface_id));
		}
		ReloadDaemonConfig();
		$SESSION->redirect("settings.php");
	}	
}


//aktualizacja konfiguracji
if($_POST)
{
	//new dBug($_POST,'',true);die;
	
	//UPDATE DEVICES
	$db->Execute('UPDATE devices SET device_disabled=? where device_name= ?', array($_POST['device_1wire'],		'1wire'));
	$db->Execute('UPDATE devices SET device_disabled=? where device_name= ?', array($_POST['device_gpio'], 		'gpio'));
	$db->Execute('UPDATE devices SET device_disabled=? where device_name= ?', array($_POST['device_pwm'], 		'pwm'));
	$db->Execute('UPDATE devices SET device_disabled=? where device_name= ?', array($_POST['device_relayboard'], 	'relayboard'));
	$db->Execute('UPDATE devices SET device_disabled=? where device_name= ?', array($_POST['device_dummy'], 	'dummy'));
	
	//SET GLOBAL SETTINGS
	$db->Execute('UPDATE settings SET setting_value=?  where setting_key= ?', array($_POST['simplify_graphs']?$_POST['simplify_graphs']:0, 	'simplify_graphs'));
	$db->Execute('UPDATE settings SET setting_value=?  where setting_key= ?', array(TimeToUnixTime($_POST['night_start']), 			'night_start'));
	$db->Execute('UPDATE settings SET setting_value=?  where setting_key= ?', array(TimeToUnixTime($_POST['night_stop']),  			'night_stop'));
	$db->Execute('UPDATE settings SET setting_value=?  where setting_key= ?', array($_POST['temp_night_corr'], 				'temp_night_corr'));
	$db->Execute('UPDATE settings SET setting_value=?  where setting_key= ?', array($_POST['location'], 					'location'));
	$db->Execute('UPDATE settings SET setting_value=?  where setting_key= ?', array(intval($_POST['calendar_days']),			'calendar_days'));
	
	//1WIRE
	foreach($_POST['sensors'] as $interface_id => $sensor)
	{
		//jesli nazwa na min 2 znaki i sensor już istnieje w tabeli sensors
		if(strlen($sensor['sensor_name'])>1 and $db->GetOne('SELECT 1 FROM interfaces WHERE interface_id=?', array($interface_id))=="1") 
		{
			if(!$sensor['sensor_conf'] or $sensor_master_set==1) //jesli nie jest ustawione lub już jakis inny został masterem
				$sensor['sensor_conf']=0;
			else
				$sensor_master_set=1;
			
			$db->Execute('UPDATE interfaces SET
						interface_name=?,
						interface_address=?,
						interface_corr=?,
						interface_nightcorr=?,
						interface_draw=?,
						interface_conf=?,
						interface_disabled=?
					WHERE interface_id=?', 
					array(
						$sensor['sensor_name'],
						'rpi:1w:'.$sensor['sensor_address'],
						$sensor['sensor_corr'],
						$sensor['sensor_nightcorr'],
						$sensor['sensor_draw'],
						$sensor['sensor_conf'],
						$sensor['sensor_disabled'],
						$interface_id
						));
			
			//jesli podano jednostke dla sensora zaktualizuj jesli nie to skasuj ew wpis
			if($sensor['sensor_unit'])
			{
				$db->Execute('DELETE FROM unitassignments WHERE unitassignment_unitid=? AND unitassignment_interfaceid=?', array($sensor['sensor_unit'], $interface_id));
				$db->Execute('INSERT INTO unitassignments(unitassignment_unitid, unitassignment_interfaceid) VALUES(?, ?)', array($sensor['sensor_unit'], $interface_id));
			}
			else
				$db->Execute('DELETE FROM unitassignments WHERE unitassignment_unitid=? AND unitassignment_interfaceid=?', array($sensor['sensor_unit'], $interface_id));
		}
		//jesli nie istnieje i jest podana nazwa dodaj czujnik
		elseif(strlen($sensor['sensor_name'])>1) 
		{
                        if(!$sensor['sensor_draw'])
                            $sensor['sensor_draw']	= 0;
			$db->Execute('INSERT INTO interfaces(interface_id, interface_deviceid, interface_address, interface_name, interface_corr, interface_draw, interface_type)
				     VALUES (?, ?, ?, ?, ?, ?, ?)',
				     array($interface_id, GetDeviceId('1wire'), 'rpi:1w:'.$sensor['sensor_address'], $sensor['sensor_name'], $sensor['sensor_corr'], $sensor['sensor_draw'], 1));
			
			//jesli podano jednostke dla sensora dodaj wpis
			if($sensor['sensor_unit'])
				$db->Execute('INSERT INTO unitassignments(unitassignment_unitid, unitassignment_interfaceid) VALUES(?, ?)', array($sensor['sensor_unit'], $interface_id));
		}
		
		
		
	}
	
	//GPIO
	foreach($_POST['gpios'] as $interface_id => $gpio)
	{
		//jesli nazwa na min 2 znaki i gpio już istnieje w tabeli sensors
		if(strlen($gpio['gpio_name'])>1 and $db->GetOne('SELECT 1 FROM interfaces WHERE interface_id=?', array($interface_id))=="1") 
		{
			$db->Execute('UPDATE interfaces SET interface_name=?, interface_address=?, interface_icon=?,  interface_draw=? WHERE interface_id=?', 
				array($gpio['gpio_name'], $gpio['gpio_address'], $gpio['gpio_icon'], $gpio['gpio_draw'], $interface_id ));
		}
		//jesli nie istnieje i jest podana nazwa dodaj gpio
		elseif(strlen($gpio['gpio_name'])>1) 
		{
			$db->Execute('INSERT INTO interfaces(interface_id, interface_deviceid, interface_address, interface_name, interface_icon)
				     VALUES (?, ?, ?, ?, ?)',
				     array($interface_id, GetDeviceId('gpio'), $gpio['gpio_address'], $gpio['gpio_name'], 'device.png'));
		}
		
	}

	//PWM
	foreach($_POST['pwms'] as $interface_id => $pwm)
	{
		//jesli nazwa na min 2 znaki i pwm już istnieje w tabeli sensors
		if(strlen($pwm['pwm_name'])>1 and $db->GetOne('SELECT 1 FROM interfaces WHERE interface_id=?', array($interface_id))=="1") 
		{
			$db->Execute('UPDATE interfaces SET interface_name=?, interface_address=?, interface_icon=?,  interface_draw=? WHERE interface_id=?', 
				array($pwm['pwm_name'], $pwm['pwm_address'], $pwm['pwm_icon'], $pwm['pwm_draw'], $interface_id ));
		}
		//jesli nie istnieje i jest podana nazwa dodaj pwm
		elseif(strlen($pwm['pwm_name'])>1) 
		{
			$db->Execute('INSERT INTO interfaces(interface_id, interface_deviceid, interface_address, interface_name, interface_icon)
				     VALUES (?, ?, ?, ?, ?)',
				     array($interface_id, GetDeviceId('pwm'), $pwm['pwm_address'], $pwm['pwm_name'], 'device.png'));
		}
	}
	
	//RELAYBOARD
	foreach($_POST['relays'] as $interface_id => $relay)
	{
		if(!$relay['sensor_draw'])
                            $relay['sensor_draw']	= 0;
		$db->Execute('UPDATE interfaces SET interface_conf=?, interface_name=?, interface_icon=?, interface_draw=? WHERE interface_id=?', 
			array($relay['relay_conf'], $relay['relay_name'], $relay['relay_icon'], $relay['relay_draw'], $interface_id));
		
	}
	
	//DUMMY
	foreach($_POST['dummies'] as $interface_id => $dummy)
	{
		//jesli nazwa na min 2 znaki i gpio już istnieje w tabeli sensors
		if(strlen($dummy['dummy_name'])>1 and $db->GetOne('SELECT 1 FROM interfaces WHERE interface_id=?', array($interface_id))=="1") 
		{
			$db->Execute('UPDATE interfaces SET interface_name=?, interface_conf=? WHERE interface_id=?', 
				array($dummy['dummy_name'], $dummy['dummy_conf'], $interface_id ));
			
			//jesli podano jednostke dla sensora zaktualizuj jesli nie to skasuj ew wpis
			if($dummy['dummy_unit'])
			{
				$db->Execute('DELETE FROM unitassignments WHERE unitassignment_unitid=? AND unitassignment_interfaceid=?', array($dummy['dummy_unit'], $interface_id));
				$db->Execute('INSERT INTO unitassignments(unitassignment_unitid, unitassignment_interfaceid) VALUES(?, ?)', array($dummy['dummy_unit'], $interface_id));
			}
			else
				$db->Execute('DELETE FROM unitassignments WHERE unitassignment_unitid=? AND unitassignment_interfaceid=?', array($dummy['dummy_unit'], $interface_id));
		}
		//jesli nie istnieje i jest podana nazwa dodaj dummy
		elseif(strlen($dummy['dummy_name'])>1) 
		{
			$db->Execute('INSERT INTO interfaces(interface_id, interface_deviceid, interface_address, interface_name, interface_conf, interface_type)
				     VALUES (?, ?, ?, ?, ?, ?)',
				     array($interface_id, GetDeviceId('dummy'), 'dummy:'.$dummy['dummy_address'], $dummy['dummy_name'], $dummy['dummy_conf'], 1));
			
			//jesli podano jednostke dla sensora dodaj wpis
			if($dummy['dummy_unit'])
				$db->Execute('INSERT INTO unitassignments(unitassignment_unitid, unitassignment_interfaceid) VALUES(?, ?)', array($dummy['dummy_unit'], $interface_id));
		}
	}
	
	//SYSTEM
	foreach($_POST['system'] as $interface_id => $system)
	{
		//jesli nazwa na min 2 znaki i sensor już istnieje w tabeli sensors
		if(strlen($system['system_name'])>1 and $db->GetOne('SELECT 1 FROM interfaces WHERE interface_id=?', array($interface_id))=="1") 
		{
			$db->Execute('UPDATE interfaces
					SET interface_name=?, interface_address=?, interface_corr=?, interface_nightcorr=?, interface_draw=?, interface_conf=?, interface_disabled=?
					WHERE interface_id=?', 
					array($system['system_name'], $system['system_address'], 0, 0, $system['system_draw'], 0, $system['system_disabled'], $interface_id ));
			
			//jesli podano jednostke dla sensora zaktualizuj jesli nie to skasuj ew wpis
			if($system['system_unit'])
			{
				$db->Execute('DELETE FROM unitassignments WHERE unitassignment_unitid=? AND unitassignment_interfaceid=?', 	array($system['system_unit'], $interface_id));
				$db->Execute('INSERT INTO unitassignments(unitassignment_unitid, unitassignment_interfaceid) VALUES(?, ?)', 	array($system['system_unit'], $interface_id));
			}
			else
				$db->Execute('DELETE FROM unitassignments WHERE unitassignment_unitid=? AND unitassignment_interfaceid=?', 	array($system['system_unit'], $interface_id));
		}
		//jesli nie istnieje i jest podana nazwa dodaj czujnik
		elseif(strlen($system['system_name'])>1) 
		{
                        if(!$system['system_draw'])
                            $system['system_draw']=0;
			$db->Execute('INSERT INTO interfaces(interface_id, interface_deviceid, interface_address, interface_name, interface_corr, interface_draw)
				     VALUES (?, ?, ?, ?, ?, ?)',
				     array($interface_id, GetDeviceId('system'), $system['system_address'], $system['system_name'], 0, $system['system_draw']));
			
			//jesli podano jednostke dla sensora dodaj wpis
			if($system['system_unit'])
				$db->Execute('INSERT INTO unitassignments(unitassignment_unitid, unitassignment_interfaceid) VALUES(?, ?)', 	array($system['system_unit'], $interface_id));
		}
		
	}
	ReloadDaemonConfig();
	$SESSION->redirect("settings.php"); //przekierowanie w celu odswierzenia zmiennej $CONFIG inicjalizowanej przed wykonaniem update
}



$devices 	= GetDevices();
$interfaces	= GetInterfaces();
$units		= GetUnits();

foreach($devices as $index => $device)
{
	$tmp[$device['device_name']]	= $device['device_disabled'];
}
$devices_status	= $tmp;

//wyłaczenie relayboard jesli nie jest aktywne w konfigu
if($CONFIG['plugins']['relayboard']==0)
{
	foreach($devices as $index => $device)
	{
		if($device['device_name']=='relayboard')
			unset($devices[$index]);
	}
	$devices	= array_values($devices);
}

$icons 		= scandir('img');
foreach($icons as $icon)
{
	if($icon === '.' or $icon === '..'
		or $icon=='device.png'
		or pathinfo('img/'.$icon, PATHINFO_EXTENSION)!='png'
		or getimagesize('img/'.$icon)[0]>26
		)
			{continue;}
	$result[] = $icon;
}
$icons	= $result;

$wlist 		= xml2array(IPC_CommandWithReply("1wlist"));
$sensors_fs	= $wlist['aquapi']['list']['item'];

if(isset($sensors_fs))
	$smarty->assign('sensors_fs', $sensors_fs);

// niech daemon powie jakie urządzena widzi
$device_list 	= @simplexml_load_string(IPC_CommandWithReply("devicelist"));
foreach ($device_list->devicelist->device as $value) {
	// sprawdź teraz czy te urządzenia nie są już skonfigurowane
	if (($db->GetOne("SELECT interface_id FROM interfaces WHERE interface_address ='?' AND interface_deleted <> 1",array($value->address)) > 0) && ($value->fully_editable_address !='yes')) {
		$value->addChild('configured', 'yes');

	}
}

//new dBug($interfaces);
//new dBug($devices_status);
$smarty->assign('new_interface_id',	$db->GetOne("select max(interface_id)+1 from interfaces"));
$smarty->assign('devices', 		$devices);
$smarty->assign('devices_status', 	$devices_status);
$smarty->assign('units', 		$units);
$smarty->assign('icons', 		$icons);
$smarty->assign('interfaces', 		$interfaces);
$smarty->assign('simplify_graphs', 	$CONFIG['simplify_graphs']);
$smarty->assign('title', 		'Ustawienia');
$smarty->assign('device_list',	$device_list);*/

$smarty->assign('cur_name', 'Edycja scenariusza');

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

$smarty->display('header.tpl');
echo "<div style='background-color: rgb(220,220,220); margin:5px;'>";
echo "<div id ='clock' draggable='true' ondragstart='drag(event)' style='width:100px; height: 50px; display:inline-block; margin:5px; padding:5px; overflow: auto; background-color: rgb(255,255,100);  background-image: url(img/icons/appbar.clock.png); background-repeat: no-repeat; background-position:  right bottom;'>";
echo("Zegar systemowy");
echo "</div>";
echo "<div id ='days' draggable='true' ondragstart='drag(event)' style='width:100px; height: 50px; display:inline-block; margin:5px; padding:5px; overflow: auto; background-color: rgb(255,255,100);  background-image: url(img/icons/appbar.calendar.week.png); background-repeat: no-repeat; background-position:  right bottom;'>";
echo("Dni tygodnia");
echo "</div>";
$interfaces	= GetInterfaces2();
foreach($interfaces as $device)
{
	if ($device["interface_type"] == 1) { 
		$background = "rgb(100,255,100)";
	} elseif ($device["interface_type"] == 2) { 
		$background = "rgb(100,100,255)";
	} else {
		$background = "rgb(255,100,100)";
	}
	
	$icon = $device["interface_icon"];
	
	echo "<div id ='".$device["interface_id"]."' draggable='true' ondragstart='drag(event)' style='width:100px; height: 50px; display:inline-block; margin:5px; padding:5px; overflow: auto; background-color: ".$background."; background-image: url(img/icons/".$icon."); background-repeat: no-repeat; background-position:  right bottom;'>";
	echo($device["interface_name"]);
	//if (interface_type == 1) { 
	//	echo "Wyj";
	//} else { 
	//	echo "Wej";
	//}
	//var_dump($device);
	echo "</div>";
}
echo "<span style='right:0px; float:right; z-index: -1; overflow: hidden;'>Paleta</span>";
echo "</div>";
echo "<script>\n";
echo "var Tablica = [];\n";
foreach($interfaces as $device)
{
	echo "Tablica[".$device["interface_id"]."] = ".$device[interface_type].";\n";
}

echo "</script>\n";
$devices_status	= $tmp;
?>
<script>
function allowDropOut(ev) {
	var data = ev.dataTransfer.getData("text");
	if ((Tablica[data]) == 2) {
		ev.preventDefault();
	}
}

function allowDropIn(ev) {
	ev.preventDefault();
}

function drag(ev) {
    ev.dataTransfer.setData("text", ev.target.id);
}

function drop(ev) {
    ev.preventDefault();
    var data = ev.dataTransfer.getData("text");
	//alert(Tablica[data])
	if ((Tablica[data]) == 2) {
		ev.target.innerHTML = document.getElementById(data).innerHTML + "<div><select style='width:200px'><option value='on'>Załącz</option><option value='off'>Wyłącz</option></select></div>";
		ev.target.style.border = "none";
		ev.target.style.backgroundColor = document.getElementById(data).style.backgroundColor;
		ev.target.style.backgroundImage = document.getElementById(data).style.backgroundImage;
		ev.target.style.backgroundRepeat = document.getElementById(data).style.backgroundRepeat;
		ev.target.style.backgroundPosition = document.getElementById(data).style.backgroundPosition;
	} else {
		alert("W tym polu można umieścić tylko element typu wyjście");
	}
}

function dropin(ev) {
    ev.preventDefault();
    var data = ev.dataTransfer.getData("text");
	var new_id = 'input' + String(parseInt(ev.target.id.substring(5).valueOf())+1 );
    //ev.target.appendChild(document.getElementById(data));
	if  ((Tablica[data]) == 2) {
		ev.target.innerHTML = document.getElementById(data).innerHTML + "<div><select style='width:200px'><option value='0'>Wyłączone</option><option value='1'>Załączone</option></select></div>";
	} else if (data == "clock") {
		ev.target.innerHTML = document.getElementById(data).innerHTML + "<div><select style='width:40px'><option value='<'><</option><option value='='>=</option><option value='>'>></option></select> <input type='text' name='refval' style='width:40px'>:<input type='text' name='refval' style='width:40px'>:<input type='text' name='refval' style='width:40px'></div>";
	} else if (data == "days") {
		ev.target.innerHTML = document.getElementById(data).innerHTML + "<div><input type='checkbox' name='pn' value='1' />Pn<input type='checkbox' name='pn' value='1' />Wt<input type='checkbox' name='pn' value='1' />Sr<input type='checkbox' name='pn' value='1' />Cz<input type='checkbox' name='pn' value='1' />Pt<input type='checkbox' name='pn' value='1' />So<input type='checkbox' name='pn' value='1' />Nd</div>";
	} else {
		ev.target.innerHTML = document.getElementById(data).innerHTML + "<div><select style='width:40px'><option value='<'><</option><option value='='>=</option><option value='>'>></option></select><input type='text' name='h' style='width:100px'></div>";
	}
	ev.target.style.border = "none";
	ev.target.style.backgroundColor = document.getElementById(data).style.backgroundColor;
	ev.target.style.backgroundImage = document.getElementById(data).style.backgroundImage;
	ev.target.style.backgroundRepeat = document.getElementById(data).style.backgroundRepeat;
	ev.target.style.backgroundPosition = document.getElementById(data).style.backgroundPosition;	
	
	if (!document.getElementById(new_id)) {
		var newDiv = document.createElement("div");
		newDiv.innerHTML = "Przeciągnij tutaj...";
		newDiv.id = new_id;
		newDiv.setAttribute("ondrop","dropin(event)");
		newDiv.setAttribute("ondragover","allowDropIn(event)");
		//newDiv.ondrop=dropin(event);
		//newDiv.ondragover=allowDrop(event);
		newDiv.style = "border:dotted; width:220px; height: 100px; display:inline-block; overflow: auto; margin:5px; padding:5px; ";
		document.getElementById("inputs").appendChild(newDiv);
	}
}
</script>
<div id="inputs" style='background-color: rgb(220,220,220); margin:5px; '><span style='right:0px; float:right; z-index: -1; overflow: hidden;'>Sygnały wejściowe</span>
<div id="input1" ondrop="dropin(event)" ondragover="allowDropIn(event)" style="border:dotted; width:220px; height: 100px; display:inline-block; overflow: auto; margin:5px; padding:5px; ">Przeciągnij tutaj...</div>
</div>
<div id="logical" style='background-color: rgb(220,220,220); margin:5px;'><span style='right:0px; float:right; z-index: -1; overflow: hidden;'>Funkcja łącząca</span>
<input type="radio" name="logic" value="AND" checked>AND
<input type="radio" name="logic" value="OR">OR
<input type="radio" name="logic" value="NOT">NOT
<input type="radio" name="logic" value="XOR">XOR
</div>
<div id="outputs" style='background-color: rgb(220,220,220); margin:5px;'><span style='right:0px; float:right; z-index: -1; overflow: hidden;'>Wyjście</span>
<div id="output" ondrop="drop(event)" ondragover="allowDropOut(event)" style="border:dotted; width:220px; height: 100px; display:inline-block; overflow: auto; margin:5px; padding:5px; ">Przeciągnij tutaj...</div>
</div>




