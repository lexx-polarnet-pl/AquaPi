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
 
$db->Execute("UPDATE settings SET setting_value = '2020011601' WHERE setting_key = 'db_version'");

$db->Execute(" CREATE TABLE `water` (
  `water_id` int(5) NOT NULL AUTO_INCREMENT,
  `water_date` int(11) DEFAULT NULL,
  `water_ph` float DEFAULT NULL,
  `water_gh` float DEFAULT NULL,
  `water_kh` float DEFAULT NULL,
  `water_no2` float DEFAULT NULL,
  `water_no3` float DEFAULT NULL,
  `water_cl2` float DEFAULT NULL,
  `water_comment` varchar(1000) COLLATE utf8_polish_ci DEFAULT NULL,
  PRIMARY KEY (`water_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COLLATE=utf8_polish_ci; ");

?>
