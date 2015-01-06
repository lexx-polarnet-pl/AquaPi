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

// To są stałe które są używane przez WebUI i przez Daemona i muszą być takie same

$globals['direction_equal'] 	= 0; // znak =
$globals['direction_greater'] 	= 1; // znak >
$globals['direction_less']		= 2; // znak <

$globals['interface_off']		= 0; // wyłączony
$globals['interface_on']		= 1; // załączony

$globals['logic_and']			= 0; // funkcja AND
$globals['logic_or']			= 1; // funkcja OR
$globals['logic_not']			= 2; // funkcja NOT
