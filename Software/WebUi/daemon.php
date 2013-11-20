#!/usr/bin/php
<?php
/*
 * AquaPi - sterownik akwariowy oparty o Raspberry Pi
 *
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
 * $Id:$
 */

/*
 * Wymaga php5-cli
 */

//
//  INIT
//
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
reload_config();

function reload_config()
{
    global $CONFIG, $DEVICES, $DB;
    $CONFIG = parse_ini_file("/etc/aquapi2.ini", true);
    
    $DEVICES= $DB->GetAll('SELECT * FROM  `devices` WHERE device_id>0 AND device_deleted=0');
    //print_r($DEVICES);
    foreach($DEVICES as $index => $device)
    {
        $tmp[$device['device_name']]=$device['device_id'];
    }
    $DEVICES = $tmp;
}
function shutdown()
{
    // This is our shutdown function, in 
    // here we can do any last operations
    // before the script is complete.
    
    echo 'Script executed with success', PHP_EOL;
}

register_shutdown_function('shutdown');

echo "Server time = ". date("Y-m-d H:i:s")."\n";
$time=$DB->GetOne('SELECT FROM_UNIXTIME(?)', array(time()));
echo "Mysql time  = ". $time."\n";
echo "\nServer & mysql time must by the same !!\n\n\n";

//
//  INIT END
//


echo "Daemon started\n";


while(true)
{
    set_time_limit(60);
    $seconds_since_midnight = time() - strtotime('today');
    $now                    = time();
    
    if($seconds_since_midnight % $CONFIG['daemon']['debug_freq'] == 0)
    {
        $debug  = '';
        $insert = '';
        echo "\n\nReading...\n";
        
        //jesli 1wire jest aktywny
        if(array_key_exists('1wire', $DEVICES ))
        {
            $debug .= "\n--== 1-WIRE ==--\n";
            $ONEWIRE=$DB->GetAll('SELECT * FROM  `interfaces` WHERE interface_id>0 AND interface_deleted=0 AND interface_deviceid=?', array($DEVICES['1wire']));
            //new dbug($ONEWIRE);
            foreach($ONEWIRE as $index => $sensor)
            {
                $address = explode(':', $sensor['interface_address']);
                //print_r($sensor);
                $temp   = Read1Wire($address[2]);
                if($temp===FALSE)
                {
                    //bład odczytu
                    SaveLog(2, 'Błąd odczytu sensora '.$address[2]);
                    continue;
                }
                $temp  += $sensor['interface_corr'];
                
                $debug .= str_pad(substr($sensor['interface_name'],0,20), 20). "\t => " . sprintf("%01.2f", $temp) . "\xc2\xb0C\n";
                
                if($seconds_since_midnight % $CONFIG['daemon']['store_freq'] == 0)
                    $DB->Execute('INSERT INTO stats (stat_date, stat_interfaceid, stat_value)
                            VALUES (?, ?, ?)', array($now, $sensor['interface_id'], $temp));
            }
            unset($temp);
            if($seconds_since_midnight % $CONFIG['daemon']['store_freq'] == 0)
                $insert .= "Saved sensors into database.\n";
        }
        
        //jesli gpio jest aktywny
        if(array_key_exists('gpio', $DEVICES ))
        {
            $debug .= "\n--== GPIO ==--\n";
            $GPIO=$DB->GetAll('SELECT * FROM  `interfaces` WHERE interface_id>0 AND interface_deleted=0 AND interface_deviceid=?', array($DEVICES['gpio']));
            //new dbug($GPIO);
            foreach($GPIO as $index => $gpiopin)
            {
                $address = explode(':', $gpiopin['interface_address']);
                if($address[1]!='gpio')
                    continue;
                $status=exec('sudo /usr/local/bin/gpio read '.$address[2]);
                
                $debug .= str_pad(substr($gpiopin['interface_name'],0,20), 20). "\t => " . $status . "\n";
                    
                if($seconds_since_midnight % $CONFIG['daemon']['store_freq'] == 0)
                    $DB->Execute('INSERT INTO stats (stat_date, stat_interfaceid, stat_value)
                                VALUES (?, ?, ?)', array($now, $gpiopin['interface_id'], $status));
            }
            if($seconds_since_midnight % $CONFIG['daemon']['store_freq'] == 0)
                $insert .= "Saved gpio into database.\n";
        }
        
        
        //jesli relayboard jest aktywny
        if(array_key_exists('relayboard', $DEVICES ))
        {
            $debug .= "\n--== RB ==--\n";
            $RB=$DB->GetAll('SELECT * FROM  `interfaces` WHERE interface_id>0 AND interface_deleted=0 AND interface_deviceid=?', array($DEVICES['relayboard']));
            //new dbug($RB);
            $status=strrev(sprintf('%1$08d', base_convert(exec('sudo '.$CONFIG['relayboard']['binary'].' '.$CONFIG['relayboard']['device']. ' get'), 16, 2)));
            
            foreach($RB as $index => $relay)
            {
                $debug .= str_pad(substr($relay['interface_name'],0,20), 20). "\t => " . $status[$index] . "\n";
                    
                if($seconds_since_midnight % $CONFIG['daemon']['store_freq'] == 0)
                    $DB->Execute('INSERT INTO stats (stat_date, stat_interfaceid, stat_value)
                                VALUES (?, ?, ?)', array($now, $relay['interface_id'], $status[$index]));
            }
            if($seconds_since_midnight % $CONFIG['daemon']['store_freq'] == 0)
                $insert .= "Saved relayboard into database.\n";
        }
    }
    echo date("Y-m-d H:i:s")."\r";
    if(isset($debug))
    {
        echo "\n".$debug."\n";
        echo $insert."\n";
        unset($debug);
        unset($insert);
    }
    
    if($seconds_since_midnight % $CONFIG['daemon']['reload_freq'] == 0)
    {
        reload_config();
        echo "\nConfig reloaded.\n";
        print_r($CONFIG);
    }
    sleep(1);
    $DB->Execute('UPDATE settings SET setting_value=?NOW? WHERE setting_key = "demon_last_activity"'); 
}

?>
