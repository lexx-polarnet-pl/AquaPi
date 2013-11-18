<?php
/*
 * AquaPi - sterownik akwariowy oparty o Raspberry Pi
 *
 * Copyright (C) 2012 Marcin Król (lexx@polarnet.pl)
 * Copyright (C) 2013 Jarosław Czarniak (jaroslaw@czarniak.org)
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

 
// wersja AquaPi
$aquapi_ver = "1.9";

// Wczytanie pliku z ustawieniami
$CONFIG = parse_ini_file("/etc/aquapi2.ini", true);

// ustawienie odpowiedniej strefy czasowej
date_default_timezone_set("Europe/Warsaw");
//date_default_timezone_set('UTC');

define('MAIN_DIR',getcwd().'/');
define('LIB_DIR', MAIN_DIR.'lib/');
define('MODULES_DIR', MAIN_DIR.'modules/');
define('ONEWIRE_DIR','/sys/bus/w1/devices');
define('SMARTY_COMPILE_DIR',MAIN_DIR.'smarty/templates_c');


if(!is_dir(SMARTY_COMPILE_DIR))
        die('Missing directory <B>'.SMARTY_COMPILE_DIR.'</B>. Can anybody make them?');

if(!is_writable(SMARTY_COMPILE_DIR))
        die('Can\'t write to directory <B>'.SMARTY_COMPILE_DIR.'</B>. Run: <BR><PRE>chown '.posix_geteuid().':'.posix_getegid().' '.SMARTY_COMPILE_DIR."\nchmod 755 ".SMARTY_COMPILE_DIR.'</PRE>This helps me to work. Thanks.');

//graficzny debug
require(LIB_DIR.'dBug.php');

// inicjalizacja smarty
require(MAIN_DIR.'smarty/libs/Smarty.class.php');
$smarty = new Smarty();

$smarty->setTemplateDir(MAIN_DIR.'/smarty/templates');
$smarty->setCompileDir(SMARTY_COMPILE_DIR);
$smarty->setCacheDir(MAIN_DIR.'smarty/cache');
$smarty->setConfigDir(MAIN_DIR.'smarty/configs');

$smarty->assign('aquapi_ver',$aquapi_ver);

// inicjalizacja bazy danych
require(LIB_DIR. 'database.class.php');
$db		= new Database($CONFIG['database']['host'], $CONFIG['database']['user'], $CONFIG['database']['password'], $CONFIG['database']['database']);

//uzupełnienie konfigu o dane z bazy
$configs=$db->GetAll('SELECT setting_key, setting_value FROM settings');
foreach($configs as $config)
    $tmp[$config['setting_key']]=$config['setting_value'];

$CONFIG		= array_merge($CONFIG, $tmp);
unset($tmp);

//init sesji
require(LIB_DIR. 'session.class.php');
$SESSION	= new Session();


//funkcje
require(LIB_DIR.'functions.php');

//IPC
require(LIB_DIR.'ipc.php');

// definicja menu
$my_menu = Array (
    Array ("selected" => false,	"name" => "Dashboard", 		"icon" => "home.png", 		"url" => "index.php"),
    Array ("selected" => false,	"name" => "Timery", 		"icon" => "timers.png", 	"url" => "timers.php"),
    Array ("selected" => false,	"name" => "Ustawienia",		"icon" => "settings.png", 	"url" => "settings.php"),
    Array ("selected" => false,	"name" => "Zdarzenia", 		"icon" => "logs.png", 		"url" => "logs.php"),
    Array ("selected" => false,	"name" => "Statystyka", 	"icon" => "stat.png", 		"url" => "stat.php"),
    Array ("selected" => false,	"name" => "O sterowniku",	"icon" => "about.png", 		"url" => "about.php")
);

$self = explode('/', $_SERVER["PHP_SELF"]);
$self = end($self);

foreach ($my_menu as &$pos) {
    if ($pos['url'] == $self) {
		$cur_name = $pos['name'];
		$pos['selected'] = true;
	}
}

$smarty->assign('my_menu', $my_menu);
$smarty->assign('cur_name', $cur_name);

//var_dump($my_menu);
?>
