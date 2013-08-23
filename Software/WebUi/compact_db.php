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

$cur_name = "compact_db";
 
include("init.php");

$db->Execute('delete from temp_stats where temp < -100;');

$data_win = 60 * 60; // domyślnie kompaktujemy w godzinie
$to		= time() - (1 * 24 * 60 * 60);	// dla ostatnich 24h zostaw kompletne dane

for ($sensor_id = 0; $sensor_id<=4; $sensor_id++) {

	$data_to_compact = $db->GetAll('select time_st,temp from temp_stats where sensor_id = '.$sensor_id.' and time_st <'.$to.' order by time_st asc');

	if ($data_to_compact != null) {
		$prev_time_fr = 0;
		$avr_counter = 0;
		$avr_total = 0;



		foreach ($data_to_compact as $value) {
			$time_fr = floor($value['time_st']/$data_win);
			if ($prev_time_fr <> $time_fr) {
				// przekroczyliśmy fragment godziny, trzeba zachować dane zebrane i wyciągać średnie od nowa
				if ($avr_counter > 1) {
					$db->Execute('START TRANSACTION;');
					$db->Execute('delete from temp_stats where sensor_id = '.$sensor_id.' and time_st >= '.$prev_time_fr*$data_win.' and  time_st < '.($prev_time_fr+1)*$data_win.';');
					$db->Execute('INSERT INTO temp_stats (time_st,sensor_id,temp) VALUES ('.$prev_time_fr*$data_win.','.$sensor_id.','.$avr_total/$avr_counter.');');
					$db->Execute('COMMIT;');
				}
				$avr_counter = 0;
				$avr_total = 0;
			}
			$prev_time_fr = $time_fr;
			$avr_counter++;
			$avr_total = $avr_total + $value['temp'];
		}
	}
}

$db->Execute('INSERT INTO log (time,level,message) VALUES ('.time().',0,"Zakończono kompaktowanie bazy danych");');
echo "done\n";

?>
