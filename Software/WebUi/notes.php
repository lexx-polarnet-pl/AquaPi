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

include("init.php");

//new dBug($_GET);
$smarty->assign('title', 'Notatki');

if ($_GET['action'] == 'add')
{
	AddNote($_POST);
	$SESSION->redirect('notes.php');
}

if ($_GET['action'] == 'delete')
{
	DeleteNote($_GET);
	$SESSION->redirect('notes.php');
}

$notes         = GetNotes();


//new dBug($notes);

$smarty->assign('notes', $notes);
$smarty->display('notes.tpl');
?>
