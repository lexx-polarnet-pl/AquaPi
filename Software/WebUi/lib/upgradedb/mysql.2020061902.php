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
 
$db->Execute("UPDATE settings SET setting_value = '2020061902' WHERE setting_key = 'db_version'");

$temp_interface_sensor = $db->GetOne("SELECT setting_value FROM settings WHERE setting_key = 'temp_interface_sensor'"); 
$temp_tminal = $db->GetOne("SELECT setting_value FROM settings WHERE setting_key = 'temp_tminal'"); 
$temp_tmaxal = $db->GetOne("SELECT setting_value FROM settings WHERE setting_key = 'temp_tmaxal'"); 

$db->Execute("INSERT INTO alarms (alarm_interface_id, alarm_action_level, alarm_direction, alarm_text)
			VALUES (?,?,'1','Temperatura mierzona przekroczyła próg alarmowy dla wartości minimalnej')", array($temp_interface_sensor, $temp_tminal));

$db->Execute("INSERT INTO alarms (alarm_interface_id, alarm_action_level, alarm_direction, alarm_text)
			VALUES (?,?,'0','Temperatura mierzona przekroczyła próg alarmowy dla wartości maksymalnej')", array($temp_interface_sensor, $temp_tmaxal));		

?>
