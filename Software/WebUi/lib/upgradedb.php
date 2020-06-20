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

define('DBVERSION', '2020062002'); 	// here should be always the newest version of database!
									// it placed here to avoid read disk every time when we call this file.

/*
 * This file contains procedures for upgradeing automagicly database.
 */

function getdir($pwd = './', $pattern = '^.*$')
{
	if ($handle = @opendir($pwd))
	{
		while (($file = readdir($handle)) !== FALSE)
			if(preg_match('/'.$pattern.'/',$file))
				$files[] = $file;
		closedir($handle);
	}
	return $files;
}

if($dbversion = $db->GetOne("SELECT setting_value FROM settings WHERE setting_key = 'db_version'")) {
	if(DBVERSION > $dbversion)
	{
		
		set_time_limit(0);

		$upgradelist = getdir(LIB_DIR.'/upgradedb/', '^mysql.[0-9]{10}.php$');

		if(sizeof($upgradelist))
			foreach($upgradelist as $upgrade)
			{
				$upgradeversion = preg_replace('/^mysql\.([0-9]{10})\.php$/','\1',$upgrade);

				if($upgradeversion > $dbversion && $upgradeversion <= DBVERSION)
					$pendingupgrades[] = $upgradeversion;
			}

		if(sizeof($pendingupgrades))
		{
			sort($pendingupgrades);
			foreach($pendingupgrades as $upgrade)
			{
				include(LIB_DIR.'/upgradedb/mysql.'.$upgrade.'.php');
			}
		}
	} 
}

?>
