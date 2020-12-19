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



function IPC_Command($command) {
	IPC_CommandWithReply($command);
}

function IPC_CommandWithReply($command) {
	$ret = "";
	$host	= $GLOBALS['CONFIG']['daemon']['bind_address'];
	$port	= $GLOBALS['CONFIG']['daemon']['bind_port'];

	$fp = @fsockopen($host, $port, $errno, $errstr, 2);
	if (!$fp) {
		//echo "$errstr ($errno)<br />\n";
		$ret = -1;
	} else {
		fwrite($fp, "aquapi:".$command."\n");
		while (!feof($fp)) {
			$ret .= fgets($fp, 128);
			//echo strpos($ret,"koniec");
		}
		fclose($fp);
	}
	return $ret;
}

?>
