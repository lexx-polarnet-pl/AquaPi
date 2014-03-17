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


if(isset($_GET['action']))
{
    if($_GET['w'])
        $options.=' -w '.$_GET['w'].' ';
    else
        $options.=' -w 800 ';
    if($_GET['h'])
        $options.=' -h '.$_GET['h'].' ';
    else
        $options.=' -h 600 ';
    if($_GET['rot'])
        $options.=' -rot '.$_GET['rot'].' ';

    system('raspistill -hf '.$options.' -o /tmp/imageembed.jpg -t 0');
    $filename   = "/tmp/imageembed.jpg";
    $handle     = fopen($filename, "rb");
    $contents   = fread($handle, filesize($filename));
    fclose($handle);
    echo $contents;
}


?>
