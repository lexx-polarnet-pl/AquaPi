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
 
// wersja AquaPi
$aquapi_ver = "1.9-devel";

// Wczytanie pliku z ustawieniami
$CONFIG = parse_ini_file("/etc/aquapi.ini", true);

if (!isset($CONFIG['webui']['purge_logs']))
    $CONFIG['webui']['purge_logs'] = 3;

if ($CONFIG['webui']['purge_logs'] < 3)
    $CONFIG['webui']['purge_logs'] = 3;

define('MAIN_DIR', $CONFIG['webui']['directory'].'/');
define('LIB_DIR', MAIN_DIR.'lib/');
define('IMG_DIR', MAIN_DIR.'img/');
define('SMARTY_COMPILE_DIR',MAIN_DIR.'smarty/templates_c/');

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

// upgrade bazy danych
require(LIB_DIR.'upgradedb.php');

//uzupełnienie konfigu o dane z bazy
$configs=$db->GetAll('SELECT setting_key, setting_value FROM settings');
foreach($configs as $config_opt)
    $CONFIG[$config_opt['setting_key']]=$config_opt['setting_value'];

// Wartości domyślne
if (!isset($CONFIG['daemon']['bind_address'])) 	{ $CONFIG['daemon']['bind_address'] = "127.0.0.1"; }
if (!isset($CONFIG['daemon']['bind_port'])) 	{ $CONFIG['daemon']['bind_port']    = 6580; }

//init sesji
require(LIB_DIR. 'session.class.php');
$SESSION	= new Session();

//funkcje
require(LIB_DIR.'functions.php');

//IPC
require(LIB_DIR.'ipc.php');

// definicja menu
$my_menu	= array();
$my_menu[]	= array ("selected" => false,	"name" => "Dashboard", 			"icon" => "fa-dashboard", 				"url" => "index.php",	"acl" => "rw"   , "reload" => 1);
$my_menu[]	= array ("selected" => false,	"name" => "Timery", 			"icon" => "fa-clock-o", 				"url" => "timers.php",	"acl" => "rw"   , "reload" => 0);
$my_menu[]	= array ("selected" => false,	"name" => "Oświetlenie",		"icon" => "fa-sun-o", 					"url" => "light.php",	"acl" => "rw"   , "reload" => 0);
$my_menu[]	= array ("selected" => false,	"name" => "Temperatura",		"icon" => "fa-umbrella", 				"url" => "temp.php",	"acl" => "rw"   , "reload" => 0);
$my_menu[]	= array ("selected" => false,	"name" => "CO<sub>2</sub>",		"icon" => "fa-flask", 					"url" => "co2.php",		"acl" => "rw"   , "reload" => 0);
$my_menu[]	= array ("selected" => false,	"name" => "Wejścia i Wyjścia",	"icon" => "fa-gears", 					"url" => "ioconf.php",	"acl" => "rw"   , "reload" => 0);
$my_menu[]	= array ("selected" => false,	"name" => "Tryb serwisowy",		"icon" => "fa-wrench", 					"url" => "service.php",	"acl" => "rw"   , "reload" => 0);
$my_menu[]	= array ("selected" => false,	"name" => "Alerty",				"icon" => "fa-bell", 					"url" => "alerts.php",	"acl" => "rw"   , "reload" => 0);
$my_menu[]	= array ("selected" => false,	"name" => "Wykresy", 			"icon" => "fa-bar-chart-o", 			"url" => "stat.php",	"acl" => "r"    , "reload" => 1);
$my_menu[]	= array ("selected" => false,	"name" => "Zdarzenia", 			"icon" => "fa-exclamation-triangle",	"url" => "logs.php",	"acl" => "r"    , "reload" => 1);
$my_menu[]	= array ("selected" => false,	"name" => "Parametry wody", 	"icon" => "fa-flask",					"url" => "water.php",	"acl" => "rw"    , "reload" => 1);
$my_menu[]	= array ("selected" => false,	"name" => "O sterowniku",		"icon" => "fa-heart", 					"url" => "about.php",	"acl" => "r"    , "reload" => 0);
if (($CONFIG['webui']['security'] == "all") || ($CONFIG['webui']['security'] == "setup")) {
	$my_menu[]	= array ("selected" => false,	"name" => "Wyloguj",		"icon" => "fa-sign-out", 					"url" => "logout.php",	"acl" => "r"    , "reload" => 0);
}


$self = explode('/', $_SERVER["PHP_SELF"]);
$self = end($self);

$SESSION -> restore('logged_in',$logged_in);
	
$cur_name	= '';

foreach ($my_menu as &$pos) 
{
    if ($pos['url'] == $self) 
    {
            $cur_name = $pos['name'];
            $pos['selected'] = true;
            if ((($CONFIG['webui']['security'] == "all") || (($CONFIG['webui']['security'] == "setup") && ($pos['acl']== "rw"))) && ($logged_in == false)) 
            {
                    // nie jesteś zalogowany
                    $SESSION -> save('old_url',$self);
                    $SESSION -> redirect('login.php');
            }
	}
}

// błędy które nie zostały przeczytane
$lastwarnlogs 	= $db->GetAll('select * from logs where log_level > 0 AND log_date > ? order by log_date desc;', array($CONFIG['log_read_time']));

$smarty->assign('lastwarnlogs', 	$lastwarnlogs);
$smarty->assign('my_menu',  $my_menu);
$smarty->assign('cur_name', $cur_name);
$smarty->assign('CONFIG',   $CONFIG);

?>
