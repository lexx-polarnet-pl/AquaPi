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
 
$db->Execute("UPDATE settings SET setting_value = '2020062501' WHERE setting_key = 'db_version'");

$ph_probe = $db->GetOne("SELECT setting_value FROM settings WHERE setting_key = 'co2_probe'"); 
$ph_raw1  = $db->GetOne("SELECT setting_value FROM settings WHERE setting_key = 'co2_mv1'"); 
$ph_cal1  = $db->GetOne("SELECT setting_value FROM settings WHERE setting_key = 'co2_ph1'"); 
$ph_raw2  = $db->GetOne("SELECT setting_value FROM settings WHERE setting_key = 'co2_mv2'"); 
$ph_cal2  = $db->GetOne("SELECT setting_value FROM settings WHERE setting_key = 'co2_ph2'"); 

$db->Execute("INSERT INTO calib_data (calib_data_interface_id, calib_data_raw1, calib_data_cal1, calib_data_raw2, calib_data_cal2)
			VALUES (?,?,?,?,?)", array($ph_probe, $ph_raw1, $ph_cal1, $ph_raw2, $ph_cal2));
?>
