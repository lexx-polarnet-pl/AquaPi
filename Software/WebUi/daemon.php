<?php
/*
 */

//graficzny debug
require(getcwd().'/'.'lib/'.'dBug.php');

// Wczytanie pliku z ustawieniami
$CONFIG = parse_ini_file("/etc/aquapi2.ini", true);

//new dbug($CONFIG );
// ustawienie odpowiedniej strefy czasowej
date_default_timezone_set("Europe/Warsaw");
//date_default_timezone_set('UTC');

define('MAIN_DIR',getcwd().'/');
define('LIB_DIR', MAIN_DIR.'lib/');
define('MODULES_DIR', MAIN_DIR.'modules/');
define('ONEWIRE_DIR','/sys/bus/w1/devices/');


// inicjalizacja bazy danych
require(LIB_DIR. 'database.class.php');
$DB		= new Database($CONFIG['database']['host'], $CONFIG['database']['user'], $CONFIG['database']['password'], $CONFIG['database']['database']);

//funkcje
require(LIB_DIR.'functions.php');

$DEVICES=$DB->GetAll('SELECT * FROM  `devices` WHERE device_id>0 AND device_deleted=0');

foreach($DEVICES as $index => $device)
{
    $DEVICES[$device['device_name']]=$device['device_id'];
    unset($DEVICES[$index]);
}

//jesli 1wire jest aktywny
if(array_key_exists('1wire', $DEVICES ))
{
    $ONEWIRE=$DB->GetAll('SELECT * FROM  `interfaces` WHERE interface_id>0 AND interface_deleted=0 AND interface_deviceid=?', array($DEVICES['1wire']));
    //new dbug($ONEWIRE);

    foreach($ONEWIRE as $index => $sensor)
    {
        

        $files1 = scandir('/sys/devices/');
        new dbug($files1 );
        
die;
        $sensor=explode(':',$sensor['interface_address']);
        new dbug($sensor);
        $lines = file(ONEWIRE_DIR. $sensor[2]. '/' . 'w1_slave');
        echo ONEWIRE_DIR. $sensor[2]. '/' . 'w1_slave';
        new dbug($lines);
    }
    
    

}







?>
