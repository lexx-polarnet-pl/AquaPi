<?php
/*
 * AquaPi - sterownik akwariowy oparty o Raspberry Pi
 *
 * Copyright (C) 2012-2014 AquaPi Developers
 * Copyright (C) 2001-2011 LMS Developers
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


class Database {

	var $_dblink	= NULL;
	var $_result	= NULL;
	var $_query	= NULL;
	var $errors	= array();
	var $debug	= FALSE;

//
//	FUNKCJE
//

	function Database($dbhost, $dbuser, $dbpasswd, $dbname) {
		$this->_dblink = mysqli_connect($dbhost, $dbuser, $dbpasswd, $dbname);
		if (!$this->_dblink) {
			die('Brak polaczenia z baza: ' . mysqli_error());
		}		
		$this->Execute("SET NAMES utf8;");
	}

	function Execute($query, $inputarray = NULL)
	{

		if(! $this->_driver_execute($this->_query_parser($query, $inputarray)))
			$this->errors[] = array(
					'query' => $this->_query,
					'error' => $this->_driver_geterror()
					);
		elseif($this->debug)
			$this->errors[] = array(
					'query' => $this->_query,
					'error' => 'DEBUG: NOERROR'
					);
		return $this->_driver_affected_rows();
	}

	function GetAll($query = NULL, $inputarray = NULL)
	{
		if($query)
			$this->Execute($query, $inputarray);

		$result = NULL;

		while($row = $this->_driver_fetchrow_assoc())
			$result[] = $row;
		
		return $result;
	}


	function GetRow($query = NULL, $inputarray = NULL)
	{
		if($query)
			$this->Execute($query, $inputarray);

		return $this->_driver_fetchrow_assoc();
	}


	function GetOne($query = NULL, $inputarray = NULL)
	{
		if($query)
			$this->Execute($query, $inputarray);

		$result = NULL;

		list($result) = $this->_driver_fetchrow_num();

		return $result;
	}


//
//	DRIVER
//
	function _driver_execute($query)
	{
		//echo $query."\n";
		$this->_query = $query;

		if($this->_result = mysqli_query($this->_dblink, $query))
			$this->_error = FALSE;
		else
			$this->_error = TRUE;
		return $this->_result;
	}

	function _query_parser($query, $inputarray = NULL)
	{

		// najpierw sparsujmy wszystkie specjalne meta śmieci.
		$query = preg_replace('/\?NOW\?/i',$this->_driver_now(),$query);
		$query = preg_replace('/\?LIKE\?/i',$this->_driver_like(),$query);
		if($inputarray)
		{
			$queryelements = explode("\0",str_replace('?',"?\0",$query));
			$query = '';
			foreach($queryelements as $queryelement)
			{
				if(strpos($queryelement,'?') !== FALSE)
				{
					list($key,$value) = each($inputarray);
					$queryelement = str_replace('?',$this->_quote_value($value),$queryelement);
				}
				$query .= $queryelement;
			}
		}
		//echo $query." <BR>\n";
		return $query;
	}

	function _quote_value($input)
	{
		// jeżeli baza danych wymaga innego eskejpowania niż to, driver
		// powinien nadpisać tą funkcję

		if($input === NULL)
			return 'NULL';
		elseif(gettype($input) == 'string')
			return '\''.addcslashes($input,"'\\\0").'\'';
		else
			return $input;
	}

	function _driver_now()
	{
		return time();
	}

	function _driver_like()
	{
		return 'LIKE';
	}

	function _driver_setencoding($name)
	{
		$this->Execute('SET NAMES ?', array($name));
	}

	function _driver_fetchrow_num()
	{
		if(! $this->_error)
			return mysqli_fetch_array($this->_result, MYSQLI_NUM);
		else
			return FALSE;
	}

	function _driver_affected_rows()
	{
		if(! $this->_error)
			return mysqli_affected_rows($this->_dblink);
		else
			return FALSE;
	}

	function _driver_geterror()
	{
		if($this->_dblink)
			return mysqli_error($this->_dblink);
		elseif($this->_query)
			return 'We\'re not connected!';
		else
			return mysqli_error();
	}

	function _driver_fetchrow_assoc($result = NULL)
	{
		if(! $this->_error)
			return mysqli_fetch_array($result ? $result : $this->_result, MYSQLI_ASSOC);
		else
			return FALSE;
	}


}

?>
