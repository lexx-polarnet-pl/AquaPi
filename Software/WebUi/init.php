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

// wersja AquaPi
$aquapi_ver = "1.9-devel";

// Wczytanie pliku z ustawieniami
$CONFIG = parse_ini_file("/etc/aquapi.ini", true);
if ($CONFIG['webui']['purge_logs'] < 7 or !isset($CONFIG['webui']['purge_logs']))
    $CONFIG['webui']['purge_logs'] = 7;

// ustawienie odpowiedniej strefy czasowej
date_default_timezone_set("Europe/Warsaw");
date_default_timezone_set('UTC');

define('MAIN_DIR',getcwd().'/');
define('LIB_DIR', MAIN_DIR.'lib/');
define('IMG_DIR', MAIN_DIR.'img/');
define('MODULES_DIR', MAIN_DIR.'modules/');
define('ONEWIRE_DIR','/sys/bus/w1/devices');
define('SMARTY_COMPILE_DIR',MAIN_DIR.'smarty/templates_c/');


if(!is_dir(SMARTY_COMPILE_DIR))
        die('Missing directory <B>'.SMARTY_COMPILE_DIR.'</B>. Can anybody make them?');

if(!is_writable(SMARTY_COMPILE_DIR))
        die('Can\'t write to directory <B>'.SMARTY_COMPILE_DIR.'</B>. Run: <BR><PRE>chown '.posix_geteuid().':'.posix_getegid().' '.SMARTY_COMPILE_DIR."\nchmod 755 ".SMARTY_COMPILE_DIR.'</PRE>This helps me to work. Thanks.');

if(!is_readable('/dev/vchiq') and file_exists('/dev/vchiq'))
	die('Can\'t read camera. Run: <BR><PRE>usermod -a -G video www-data</PRE>This helps me to work. Thanks.');
	
//if(!is_writable(IMG_DIR))
//        die('Can\'t write to directory <B>'.IMG_DIR.'</B>. Run: <BR><PRE>chown '.posix_geteuid().':'.posix_getegid().' '.SMARTY_COMPILE_DIR."\nchmod 755 ".IMG_DIR.'</PRE>This helps me to work. Thanks.');
	
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

//mobile detect
require(LIB_DIR.'Mobile_Detect.php');
$detect = new Mobile_Detect;

// definicja menu
$my_menu	= array();
$my_menu[]	= array ("selected" => false,	"name" => "Dashboard", 		"icon" => "home.png", 		"url" => "index.php",	"acl" => "r"    , "reload" => 1);
$my_menu[]	= array ("selected" => false,	"name" => "Timery", 		"icon" => "timers.png", 	"url" => "timers.php",	"acl" => "rw"   , "reload" => 0);
$my_menu[]	= array ("selected" => false,	"name" => "Ustawienia",		"icon" => "settings.png", 	"url" => "settings.php","acl" => "rw"   , "reload" => 0);
$my_menu[]	= array ("selected" => false,	"name" => "Zdarzenia", 		"icon" => "logs2.png", 		"url" => "logs.php",	"acl" => "r"    , "reload" => 1);
$my_menu[]	= array ("selected" => false,	"name" => "Statystyka", 	"icon" => "graph.png", 		"url" => "stat.php",	"acl" => "r"    , "reload" => 1);
if($CONFIG['plugins']['camera']==1)
    $my_menu[]	= array ("selected" => false,	"name" => "Kamera", 		"icon" => "camera.png", 	"url" => "camera.php",	"acl" => "r"    , "reload" => 1);
$my_menu[]	= array ("selected" => false,	"name" => "O sterowniku",	"icon" => "about.png", 		"url" => "about.php",	"acl" => "r"    , "reload" => 0);


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
    if ($pos['reload'] == 1)
        $reloadtime = '<meta http-equiv="refresh" content="120" >';
    }
}

//new dbug($CONFIG);


$smarty->assign('reloadtime',   $reloadtime);
$smarty->assign('my_menu',  $my_menu);
$smarty->assign('ismobile', $detect->isMobile());
$smarty->assign('cur_name', $cur_name);
$smarty->assign('CONFIG',   $CONFIG);

?>
