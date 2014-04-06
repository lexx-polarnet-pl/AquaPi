#!/usr/bin/php
<?php
$CONFIG 	= parse_ini_file("/etc/aquapi.ini", true);
require($CONFIG['webui']['directory'].'/init.php');


//print_r($CONFIG);die;

//$city		= 'Gda%C5%84sk';
$weather	= json_decode(file_get_contents('http://api.openweathermap.org/data/2.5/weather?q='.$CONFIG['location'].'&units=metric'));


if(isset($argv['1']))
{
    $file = '/tmp/city.temp';
    file_put_contents($file, $weather->main->temp);

    $file = '/tmp/city.pressure';
    file_put_contents($file, $weather->main->pressure);

    $file = '/tmp/city.humidity';
    file_put_contents($file, $weather->main->humidity);
}




/*
stdClass Object
(
    [coord] => stdClass Object
        (
            [lon] => 18.65
            [lat] => 54.35
        )

    [sys] => stdClass Object
        (
            [message] => 0.2055
            [country] => Poland
            [sunrise] => 1396239532
            [sunset] => 1396286401
        )

    [weather] => Array
        (
            [0] => stdClass Object
                (
                    [id] => 803
                    [main] => Clouds
                    [description] => broken clouds
                    [icon] => 04n
                )

        )

    [base] => cmc stations
    [main] => stdClass Object
        (
            [temp] => 3
            [pressure] => 1013
            [humidity] => 86
            [temp_min] => 3
            [temp_max] => 3
        )

    [wind] => stdClass Object
        (
            [speed] => 2.6
            [deg] => 50
            [var_beg] => 350
            [var_end] => 90
        )

    [clouds] => stdClass Object
        (
            [all] => 75
        )

    [dt] => 1396292400
    [id] => 3099434
    [name] => Gdansk
    [cod] => 200
)

*/
?>