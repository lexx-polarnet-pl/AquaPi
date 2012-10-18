<?php

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

class driver_mysql {

	var $_dblink;
	var $_result;
	function driver_mysql($dbhost, $dbuser, $dbpasswd, $dbname) {

		$this->_dblink = mysql_connect($dbhost, $dbuser, $dbpasswd);
		mysql_select_db($dbname);
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

$db = new driver_mysql("localhost","aquapi","aquapi","aquapi");

?>
