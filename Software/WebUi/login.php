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
 
include("init.php");

if ((@$_POST['login'] == $CONFIG['webui']['login']) && (@$_POST['password'] == $CONFIG['webui']['password'])) {
	$SESSION -> restore('old_url',$old_url);
	$SESSION -> save('logged_in',true);
	if ($old_url != null) {
		$SESSION -> redirect($old_url);
	} else {
		$SESSION -> redirect("index.php");
	}
} else {
	$smarty->assign('cur_name', "Ta sekcja wymaga zalogowania");
	$SESSION -> save('logged_in',false);
	if (isset($_POST['login'])) {
		$e_msg = "Zły login lub hasło";
		$smarty->assign('e_msg', $e_msg);
	} 
	$smarty->display('login.tpl');
}
?>

