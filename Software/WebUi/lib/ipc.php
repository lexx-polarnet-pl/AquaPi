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
 * $Id$
 */
$myfifo = "/tmp/aquapi.cmd";
$myfifo2 = "/tmp/aquapi.res";


function IPC_Command($command) {
	global $myfifo;
	$fp=fopen($myfifo, "r+"); // ensures at least one writer (us) so will be non-blocking
	stream_set_blocking($fp, false);
	fwrite($fp, "aquapi:".$command);
	fclose($fp); 
}

function IPC_GetPid() {
	global $myfifo,$myfifo2;
	IPC_Command("about");

	$fp2=fopen($myfifo2, "r+"); // ensures at least one writer (us) so will be non-blocking
	stream_set_blocking($fp2, false);
	$failcount =0;
	do {
	    if ($failcount > 0) usleep(100000);
	    $failcount++;
	    $data = fread($fp2,1024);
	    if (strrpos($data,"aquapi>about>end of reply") > 0) break;
	} while ($failcount < 3);
	fclose($fp2); 

	if ($failcount == 3) {
	    $ret = -1;
	} else {
	    foreach (explode("\n",$data) as $line) {
		if (strstr($line, "aquapi>about>PID:")!==false) {
			$ret = intval(substr($line,17));
		}
	    }
	}
	return $ret;
}

function IPC_GetDaemonData() {
	global $myfifo,$myfifo2;
	IPC_Command("about");

	$fp2=fopen($myfifo2, "r+"); // ensures at least one writer (us) so will be non-blocking
	stream_set_blocking($fp2, false);
	$failcount =0;
	do {
	    if ($failcount > 0) usleep(100000);
	    $failcount++;
	    $data = fread($fp2,1024);
	    if (strrpos($data,"aquapi>about>end of reply") > 0) break;
	} while ($failcount < 3);
	fclose($fp2); 

	if ($failcount == 3) {
	    $pid = -1;
	} else {
	    foreach (explode("\n",$data) as $line) {
		if (strstr($line, "aquapi>about>PID:")!==false) {
			$pid = intval(substr($line,17));
		}
		if (strstr($line, "aquapi>about>compilation:")!==false) {
			$compilation = substr($line,25);
		}		
	    }
	}
	return array("pid" => $pid, "compilation" => $compilation);
}

function IPC_CommandWithReply($command) {
	global $myfifo,$myfifo2;
	IPC_Command($command);

	$fp2=fopen($myfifo2, "r+"); // ensures at least one writer (us) so will be non-blocking
	stream_set_blocking($fp2, false);
	$failcount =0;
	do {
	    if ($failcount > 0) usleep(100000);
	    $failcount++;
	    $data = fread($fp2,10000);
	    if (strrpos($data,"<reply type=\"".$command."\"/>") > 0) break;
	} while ($failcount < 3);
	fclose($fp2); 

	if ($failcount == 3) {
	    $ret = -1;
	} else {
	    $ret = $data;
	}
	return $ret;
}
?>
