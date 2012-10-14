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
 
// ustawienie odpowiedniej strefy czasowej

date_default_timezone_set("Europe/Warsaw");

// inicjalizacja smarty
require('/var/www/smarty/libs/Smarty.class.php');
$smarty = new Smarty();

$smarty->setTemplateDir('/var/www/smarty/templates');
$smarty->setCompileDir('/var/www/smarty/templates_c');
$smarty->setCacheDir('/var/www/smarty/cache');
$smarty->setConfigDir('/var/www/smarty/configs');

// inicjalizacja bazy danych
class MyDB extends SQLite3
{
    function __construct() {
        $this->open('/usr/share/aquapi/aquapi.db');
    }
	
	function GetAll($query) {
		$result = $this->query($query);
		$res = null;
		while ($entry = $result->fetchArray()) {
			$res[] = $entry;
		}		
		return $res;
	}
	function GetOne($query) {
		$result = $this->query($query);
		$entry = $result->fetchArray();
		return $entry[0];
	}	
}

$db = new MyDB();

?>
