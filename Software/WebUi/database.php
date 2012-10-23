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
 * $Id$
 */
 
// inicjalizacja bazy danych

class Database {

	var $_dblink;
	var $_result;
	function Database($dbhost, $dbuser, $dbpasswd, $dbname) {

		$this->_dblink = mysql_connect($dbhost, $dbuser, $dbpasswd);
		if (!$this->_dblink) {
			die('Brak polaczenia z baza: ' . mysql_error());
		}		
		$this->_dbselected = mysql_select_db($dbname);
		if (!$this->_dbselected) {
			die ('Nie mozna wybraz bazy: ' . mysql_error());
		}		
	}

	function Execute($query) {
		$this->_result = @mysql_query($query, $this->_dblink);
	}

	function GetAll($query) {
		$this->Execute($query);
		$result = NULL;
		while($row = @mysql_fetch_array($this->_result, MYSQL_ASSOC))
		$result[] = $row;
		return $result;
	}
	function GetOne($query) {
		$this->Execute($query);
		$result = NULL;
		list($result) = @mysql_fetch_array($this->_result, MYSQL_NUM);
		return $result;
	}
}

?>
