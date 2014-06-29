-- phpMyAdmin SQL Dump
-- version 3.4.11.1deb1
-- http://www.phpmyadmin.net
--
-- Host: storage
-- Czas wygenerowania: 18 Mar 2014, 16:50
-- Wersja serwera: 5.1.49
-- Wersja PHP: 5.4.6-1ubuntu1.5

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Baza danych: `aquapi`
--

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `devices`
--
-- Tworzenie: 16 Lis 2013, 17:28
--

DROP TABLE IF EXISTS `devices`;
CREATE TABLE IF NOT EXISTS `devices` (
  `device_id` int(5) NOT NULL AUTO_INCREMENT,
  `device_name` char(40) COLLATE utf8_polish_ci NOT NULL,
  `device_disabled` tinyint(4) NOT NULL DEFAULT '0',
  `device_deleted` tinyint(4) NOT NULL DEFAULT '0',
  PRIMARY KEY (`device_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_polish_ci AUTO_INCREMENT=9 ;

--
-- Zrzut danych tabeli `devices`
--

INSERT INTO `devices` (`device_id`, `device_name`, `device_disabled`, `device_deleted`) VALUES(0, '0', 0, 0);
INSERT INTO `devices` (`device_id`, `device_name`, `device_disabled`, `device_deleted`) VALUES(1, '1wire', 0, 0);
INSERT INTO `devices` (`device_id`, `device_name`, `device_disabled`, `device_deleted`) VALUES(4, 'gpio', 1, 0);
INSERT INTO `devices` (`device_id`, `device_name`, `device_disabled`, `device_deleted`) VALUES(5, 'pwm', 1, 0);
INSERT INTO `devices` (`device_id`, `device_name`, `device_disabled`, `device_deleted`) VALUES(6, 'relayboard', 0, 0);
INSERT INTO `devices` (`device_id`, `device_name`, `device_disabled`, `device_deleted`) VALUES(7, 'dummy', 0, 0);
INSERT INTO `devices` (`device_id`, `device_name`, `device_disabled`, `device_deleted`) VALUES(8, 'system', 0, 0);

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `gpios`
--

DROP TABLE IF EXISTS `gpios`;
CREATE TABLE IF NOT EXISTS `gpios` (
  `gpio_id` int(11) NOT NULL AUTO_INCREMENT,
  `gpio_revision` tinyint(4) NOT NULL,
  `gpio_pin` tinyint(4) NOT NULL,
  `gpio_number` tinyint(4) NOT NULL,
  PRIMARY KEY (`gpio_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_polish_ci COMMENT='lista pinów gpio' AUTO_INCREMENT=17 ;

--
-- Zrzut danych tabeli `gpios`
--

INSERT INTO `gpios` (`gpio_id`, `gpio_revision`, `gpio_pin`, `gpio_number`) VALUES
(1, 1, 7, 4),
(2, 1, 11, 17),
(3, 1, 13, 21),
(4, 1, 15, 22),
(5, 1, 12, 18),
(6, 1, 16, 23),
(7, 1, 18, 24),
(8, 1, 22, 25),
(9, 2, 7, 4),
(10, 2, 11, 17),
(11, 2, 13, 27),
(12, 2, 15, 22),
(13, 2, 12, 18),
(14, 2, 16, 23),
(15, 2, 18, 24),
(16, 2, 22, 25);

-- --------------------------------------------------------



--
-- Struktura tabeli dla tabeli `interfaces`
--
-- Tworzenie: 18 Mar 2014, 10:08
--

DROP TABLE IF EXISTS `interfaces`;
CREATE TABLE IF NOT EXISTS `interfaces` (
  `interface_id` int(5) NOT NULL AUTO_INCREMENT,
  `interface_deviceid` int(5) NOT NULL,
  `interface_address` varchar(30) COLLATE utf8_polish_ci NOT NULL,
  `interface_name` varchar(30) COLLATE utf8_polish_ci NOT NULL,
  `interface_type` tinyint(4) NOT NULL DEFAULT '1' COMMENT '0-temp zadana,1-1wire temp,2-przekaznik',
  `interface_corr` varchar(6) COLLATE utf8_polish_ci NOT NULL DEFAULT '0' COMMENT 'korekta wartosci sensora',
  `interface_nightcorr` tinyint(4) NOT NULL COMMENT 'czy korygowac czujnik w nocy',
  `interface_draw` tinyint(4) NOT NULL DEFAULT '1' COMMENT 'czy pokazywac czujnik na wykresie',
  `interface_icon` varchar(20) COLLATE utf8_polish_ci DEFAULT NULL,
  `interface_conf` float DEFAULT NULL,
  `interface_disabled` tinyint(4) NOT NULL DEFAULT '0',
  `interface_deleted` tinyint(4) NOT NULL DEFAULT '0' COMMENT 'czy interfejs jest skasowany',
  PRIMARY KEY (`interface_id`),
  KEY `device_id` (`interface_deviceid`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_polish_ci AUTO_INCREMENT=30 ;

--
-- Zrzut danych tabeli `interfaces`
--

INSERT INTO `interfaces` (`interface_id`, `interface_deviceid`, `interface_address`, `interface_name`, `interface_type`, `interface_corr`, `interface_nightcorr`, `interface_draw`, `interface_icon`, `interface_conf`, `interface_disabled`, `interface_deleted`) VALUES(0, 0, 'none', 'Temperatura zadana', -1, '0', 0, 1, NULL, NULL, 0, 0);
INSERT INTO `interfaces` (`interface_id`, `interface_deviceid`, `interface_address`, `interface_name`, `interface_type`, `interface_corr`, `interface_nightcorr`, `interface_draw`, `interface_icon`, `interface_conf`, `interface_disabled`, `interface_deleted`) VALUES(11, 4, 'rpi:gpio:4', 'Oświetlenie', 2, '0', 0, 1, 'cooling.png', 0, 0, 0);
INSERT INTO `interfaces` (`interface_id`, `interface_deviceid`, `interface_address`, `interface_name`, `interface_type`, `interface_corr`, `interface_nightcorr`, `interface_draw`, `interface_icon`, `interface_conf`, `interface_disabled`, `interface_deleted`) VALUES(12, 4, 'rpi:gpio:1', 'Grzałka', 2, '0', 0, 1, 'alert.png', NULL, 0, 0);
INSERT INTO `interfaces` (`interface_id`, `interface_deviceid`, `interface_address`, `interface_name`, `interface_type`, `interface_corr`, `interface_nightcorr`, `interface_draw`, `interface_icon`, `interface_conf`, `interface_disabled`, `interface_deleted`) VALUES(13, 4, 'rpi:gpio:5', 'Wentylator', 2, '0', 0, 1, 'day.png', NULL, 0, 0);
INSERT INTO `interfaces` (`interface_id`, `interface_deviceid`, `interface_address`, `interface_name`, `interface_type`, `interface_corr`, `interface_nightcorr`, `interface_draw`, `interface_icon`, `interface_conf`, `interface_disabled`, `interface_deleted`) VALUES(14, 4, 'rpi:gpio:6', 'Oświetlenie 2', 2, '0', 0, 1, 'heater.png', NULL, 0, 0);
INSERT INTO `interfaces` (`interface_id`, `interface_deviceid`, `interface_address`, `interface_name`, `interface_type`, `interface_corr`, `interface_nightcorr`, `interface_draw`, `interface_icon`, `interface_conf`, `interface_disabled`, `interface_deleted`) VALUES(6, 5, 'rpi:gpio:18', 'PWM1', 1, '0', 0, 0, 'device.png', NULL, 0, 0);
INSERT INTO `interfaces` (`interface_id`, `interface_deviceid`, `interface_address`, `interface_name`, `interface_type`, `interface_corr`, `interface_nightcorr`, `interface_draw`, `interface_icon`, `interface_conf`, `interface_disabled`, `interface_deleted`) VALUES(15, 7, 'dummy:0', 'Fake1', 1, '0', 0, 1, NULL, 23.5, 0, 0);
INSERT INTO `interfaces` (`interface_id`, `interface_deviceid`, `interface_address`, `interface_name`, `interface_type`, `interface_corr`, `interface_nightcorr`, `interface_draw`, `interface_icon`, `interface_conf`, `interface_disabled`, `interface_deleted`) VALUES(16, 6, 'relbrd:ttyUSB0:1', 'nr 1', 2, '0', 0, 1, 'favicon.png', 0, 0, 0);
INSERT INTO `interfaces` (`interface_id`, `interface_deviceid`, `interface_address`, `interface_name`, `interface_type`, `interface_corr`, `interface_nightcorr`, `interface_draw`, `interface_icon`, `interface_conf`, `interface_disabled`, `interface_deleted`) VALUES(17, 6, 'relbrd:ttyUSB0:2', 'nr 2', 2, '0', 0, 1, 'favicon.png', 0, 0, 0);
INSERT INTO `interfaces` (`interface_id`, `interface_deviceid`, `interface_address`, `interface_name`, `interface_type`, `interface_corr`, `interface_nightcorr`, `interface_draw`, `interface_icon`, `interface_conf`, `interface_disabled`, `interface_deleted`) VALUES(18, 6, 'relbrd:ttyUSB0:3', 'nr 3', 2, '0', 0, 1, 'favicon.png', 0, 0, 0);
INSERT INTO `interfaces` (`interface_id`, `interface_deviceid`, `interface_address`, `interface_name`, `interface_type`, `interface_corr`, `interface_nightcorr`, `interface_draw`, `interface_icon`, `interface_conf`, `interface_disabled`, `interface_deleted`) VALUES(19, 6, 'relbrd:ttyUSB0:4', 'nr 4', 2, '0', 0, 1, 'favicon.png', 0, 0, 0);
INSERT INTO `interfaces` (`interface_id`, `interface_deviceid`, `interface_address`, `interface_name`, `interface_type`, `interface_corr`, `interface_nightcorr`, `interface_draw`, `interface_icon`, `interface_conf`, `interface_disabled`, `interface_deleted`) VALUES(20, 6, 'relbrd:ttyUSB0:5', 'nr 5', 2, '0', 0, 1, 'favicon.png', 0, 0, 0);
INSERT INTO `interfaces` (`interface_id`, `interface_deviceid`, `interface_address`, `interface_name`, `interface_type`, `interface_corr`, `interface_nightcorr`, `interface_draw`, `interface_icon`, `interface_conf`, `interface_disabled`, `interface_deleted`) VALUES(21, 6, 'relbrd:ttyUSB0:6', 'nr 6', 2, '0', 0, 1, 'favicon.png', 0, 0, 0);
INSERT INTO `interfaces` (`interface_id`, `interface_deviceid`, `interface_address`, `interface_name`, `interface_type`, `interface_corr`, `interface_nightcorr`, `interface_draw`, `interface_icon`, `interface_conf`, `interface_disabled`, `interface_deleted`) VALUES(22, 6, 'relbrd:ttyUSB0:7', 'Lampa prawa', 2, '0', 0, 1, 'lamp.png', 1, 0, 0);
INSERT INTO `interfaces` (`interface_id`, `interface_deviceid`, `interface_address`, `interface_name`, `interface_type`, `interface_corr`, `interface_nightcorr`, `interface_draw`, `interface_icon`, `interface_conf`, `interface_disabled`, `interface_deleted`) VALUES(23, 6, 'relbrd:ttyUSB0:8', 'Lampa lewa', 2, '0', 0, 1, 'lamp.png', 1, 0, 0);
INSERT INTO `interfaces` (`interface_id`, `interface_deviceid`, `interface_address`, `interface_name`, `interface_type`, `interface_corr`, `interface_nightcorr`, `interface_draw`, `interface_icon`, `interface_conf`, `interface_disabled`, `interface_deleted`) VALUES(29, 8, 'rpi:system:cputemp', 'cputemp', 3, '0', 0, 1, NULL, 0, 0, 0);

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `logs`
--
-- Tworzenie: 20 Lis 2013, 15:52
--

DROP TABLE IF EXISTS `logs`;
CREATE TABLE IF NOT EXISTS `logs` (
  `log_id` int(5) NOT NULL AUTO_INCREMENT,
  `log_date` int(5) NOT NULL,
  `log_level` int(5) NOT NULL,
  `log_value` char(200) COLLATE utf8_polish_ci NOT NULL,
  PRIMARY KEY (`log_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_polish_ci AUTO_INCREMENT=1 ;

--
-- Zrzut danych tabeli `logs`
--

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `settings`
--
-- Tworzenie: 22 Lis 2013, 21:22
--

DROP TABLE IF EXISTS `settings`;
CREATE TABLE IF NOT EXISTS `settings` (
  `setting_id` int(5) NOT NULL AUTO_INCREMENT,
  `setting_key` char(30) COLLATE utf8_polish_ci NOT NULL,
  `setting_value` char(60) COLLATE utf8_polish_ci NOT NULL,
  PRIMARY KEY (`setting_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_polish_ci AUTO_INCREMENT=31 ;

--
-- Zrzut danych tabeli `settings`
--

INSERT INTO `settings` (`setting_id`, `setting_key`, `setting_value`) VALUES(2, 'temp_night_corr', '-1.0');
INSERT INTO `settings` (`setting_id`, `setting_key`, `setting_value`) VALUES(3, 'hysteresis', '0.3');
INSERT INTO `settings` (`setting_id`, `setting_key`, `setting_value`) VALUES(4, 'night_start', '81000');
INSERT INTO `settings` (`setting_id`, `setting_key`, `setting_value`) VALUES(5, 'night_stop', '21600');
INSERT INTO `settings` (`setting_id`, `setting_key`, `setting_value`) VALUES(23, 'demon_last_activity', '1394977489');
INSERT INTO `settings` (`setting_id`, `setting_key`, `setting_value`) VALUES(28, 'simplify_graphs', '0');
INSERT INTO `settings` (`setting_id`, `setting_key`, `setting_value`) VALUES(29, 'max_daemon_inactivity', '180');
INSERT INTO `settings` (`setting_id`, `setting_key`, `setting_value`) VALUES(30, 'db_version', '20140318');
INSERT INTO `settings` (`setting_id`, `setting_key`, `setting_value`) VALUES(31, 'location', 'Gdańsk');
INSERT INTO `settings` (`setting_id`, `setting_key`, `setting_value`) VALUES(32, 'calendar_days', '14');
-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `stats`
--
-- Tworzenie: 14 Lis 2013, 20:53
--

DROP TABLE IF EXISTS `stats`;
CREATE TABLE IF NOT EXISTS `stats` (
  `stat_id` int(11) NOT NULL AUTO_INCREMENT,
  `stat_date` int(11) DEFAULT NULL,
  `stat_interfaceid` int(5) NOT NULL,
  `stat_value` float NOT NULL,
  PRIMARY KEY (`stat_id`),
  KEY `deviceid` (`stat_interfaceid`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_polish_ci AUTO_INCREMENT= 1;

--
-- Zrzut danych tabeli `stats`
--

-- --------------------------------------------------------

--
-- Zastąpiona struktura widoku `stats_view`
--
DROP VIEW IF EXISTS `stats_view`;
-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `timers`
--
-- Tworzenie: 23 Lis 2013, 20:35
--

DROP TABLE IF EXISTS `timers`;
CREATE TABLE IF NOT EXISTS `timers` (
  `timer_id` int(5) NOT NULL AUTO_INCREMENT,
  `timer_type` tinyint(4) NOT NULL COMMENT '1-czas, 2-1wire',
  `timer_timeif` int(5) DEFAULT NULL,
  `timer_interfaceidif` int(5) DEFAULT NULL,
  `timer_direction` tinyint(4) NOT NULL COMMENT '1 >, 2 <',
  `timer_value` float DEFAULT NULL COMMENT 'wartosc interfejsu na ktora reagujemy',
  `timer_action` tinyint(4) NOT NULL COMMENT '0 - wyłacz, 1-włacz',
  `timer_interfaceidthen` int(5) NOT NULL COMMENT 'ktory interfejs przelaczyc jest prawda',
  `timer_days` varchar(7) COLLATE utf8_polish_ci NOT NULL COMMENT 'w jakie dni reagowac',
  PRIMARY KEY (`timer_id`),
  KEY `timer_interfaceid` (`timer_interfaceidif`),
  KEY `timer_interfaceid2` (`timer_interfaceidthen`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_polish_ci AUTO_INCREMENT=1 ;

--
-- Zrzut danych tabeli `timers`
--


-- --------------------------------------------------------


--
-- Struktura tabeli dla tabeli `unitassignments`
--

DROP TABLE IF EXISTS `unitassignments`;
CREATE TABLE IF NOT EXISTS `unitassignments` (
  `unitassignment_id` int(11) NOT NULL AUTO_INCREMENT,
  `unitassignment_interfaceid` int(11) NOT NULL,
  `unitassignment_unitid` int(11) NOT NULL,
  PRIMARY KEY (`unitassignment_id`),
  KEY `unitassignment_interfaceid` (`unitassignment_interfaceid`,`unitassignment_unitid`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_polish_ci COMMENT='tablica par interfejsów i jednostek' AUTO_INCREMENT=33 ;

--
-- Zrzut danych tabeli `unitassignments`
--


-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `units`
--

DROP TABLE IF EXISTS `units`;
CREATE TABLE IF NOT EXISTS `units` (
  `unit_id` int(11) NOT NULL AUTO_INCREMENT,
  `unit_name` varchar(32) COLLATE utf8_polish_ci NOT NULL,
  PRIMARY KEY (`unit_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_polish_ci COMMENT='tablica jednostek' AUTO_INCREMENT=10 ;

--
-- Zrzut danych tabeli `units`
--

INSERT INTO `units` (`unit_id`, `unit_name`) VALUES
(1, '°C'),
(2, 'pH'),
(3, 'hPa'),
(4, 'm/s'),
(5, 'mm'),
(6, 's'),
(7, 'm'),
(8, 'h'),
(9, '%');


--
-- Table structure for table `notes`
--

CREATE TABLE IF NOT EXISTS `notes` (
  `note_id` int(11) NOT NULL AUTO_INCREMENT,
  `note_title` varchar(128) COLLATE utf8_polish_ci DEFAULT NULL,
  `note_content` text COLLATE utf8_polish_ci NOT NULL,
  `note_deleted` tinyint(4) NOT NULL DEFAULT '0',
  PRIMARY KEY (`note_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COLLATE=utf8_polish_ci AUTO_INCREMENT=1;

-- --------------------------------------------------------


--
-- Struktura tabeli dla tabeli `calendar_calendars`
--

CREATE TABLE IF NOT EXISTS `calendar_calendars` (
  `cid` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `hours_24` tinyint(1) NOT NULL DEFAULT '0',
  `date_format` tinyint(1) NOT NULL DEFAULT '0',
  `week_start` tinyint(1) NOT NULL DEFAULT '0',
  `subject_max` smallint(5) unsigned NOT NULL DEFAULT '50',
  `events_max` tinyint(4) unsigned NOT NULL DEFAULT '8',
  `title` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT 'PHP-Calendar',
  `anon_permission` tinyint(1) NOT NULL DEFAULT '1',
  `timezone` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `language` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `theme` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`cid`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=2 ;

--
-- Zrzut danych tabeli `calendar_calendars`
--

INSERT INTO `calendar_calendars` (`cid`, `hours_24`, `date_format`, `week_start`, `subject_max`, `events_max`, `title`, `anon_permission`, `timezone`, `language`, `theme`) VALUES
(1, 1, 1, 1, 50, 8, 'Kalendarz', 3, 'Europe/Warsaw', 'pl_PL', 'hot-sneaks');

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `calendar_categories`
--

CREATE TABLE IF NOT EXISTS `calendar_categories` (
  `catid` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `cid` int(11) unsigned NOT NULL,
  `gid` int(11) unsigned DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `text_color` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `bg_color` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`catid`),
  KEY `cid` (`cid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `calendar_events`
--

CREATE TABLE IF NOT EXISTS `calendar_events` (
  `eid` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `cid` int(11) unsigned NOT NULL,
  `owner` int(11) unsigned NOT NULL DEFAULT '0',
  `subject` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `description` text COLLATE utf8_unicode_ci NOT NULL,
  `readonly` tinyint(1) NOT NULL DEFAULT '0',
  `catid` int(11) unsigned DEFAULT NULL,
  `ctime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `mtime` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`eid`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `calendar_groups`
--

CREATE TABLE IF NOT EXISTS `calendar_groups` (
  `gid` int(11) NOT NULL AUTO_INCREMENT,
  `cid` int(11) DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`gid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `calendar_logins`
--

CREATE TABLE IF NOT EXISTS `calendar_logins` (
  `uid` int(11) unsigned NOT NULL,
  `series` char(43) COLLATE utf8_unicode_ci NOT NULL,
  `token` char(43) COLLATE utf8_unicode_ci NOT NULL,
  `atime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`uid`,`series`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `calendar_occurrences`
--

CREATE TABLE IF NOT EXISTS `calendar_occurrences` (
  `oid` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `eid` int(11) unsigned NOT NULL,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `start_ts` timestamp NULL DEFAULT NULL,
  `end_ts` timestamp NULL DEFAULT NULL,
  `time_type` tinyint(4) NOT NULL DEFAULT '0',
  PRIMARY KEY (`oid`),
  KEY `eid` (`eid`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `calendar_permissions`
--

CREATE TABLE IF NOT EXISTS `calendar_permissions` (
  `cid` int(11) unsigned NOT NULL,
  `uid` int(11) unsigned NOT NULL,
  `read` tinyint(1) NOT NULL,
  `write` tinyint(1) NOT NULL,
  `readonly` tinyint(1) NOT NULL,
  `modify` tinyint(1) NOT NULL,
  `admin` tinyint(1) NOT NULL,
  UNIQUE KEY `cid` (`cid`,`uid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `calendar_users`
--

CREATE TABLE IF NOT EXISTS `calendar_users` (
  `uid` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `username` varchar(32) COLLATE utf8_unicode_ci NOT NULL,
  `password` varchar(32) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `admin` tinyint(4) NOT NULL DEFAULT '0',
  `password_editable` tinyint(1) NOT NULL DEFAULT '1',
  `timezone` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `language` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `gid` int(11) DEFAULT NULL,
  PRIMARY KEY (`uid`),
  UNIQUE KEY `username` (`username`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=2 ;

--
-- Zrzut danych tabeli `calendar_users`
--

INSERT INTO `calendar_users` (`uid`, `username`, `password`, `admin`, `password_editable`, `timezone`, `language`, `gid`) VALUES
(1, 'aquapi', '3d65f08b5a0c07eee69230c186261428', 1, 1, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `calendar_user_groups`
--

CREATE TABLE IF NOT EXISTS `calendar_user_groups` (
  `gid` int(11) DEFAULT NULL,
  `uid` int(11) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `calendar_version`
--

CREATE TABLE IF NOT EXISTS `calendar_version` (
  `version` smallint(5) unsigned NOT NULL DEFAULT '1'
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Zrzut danych tabeli `calendar_version`
--

INSERT INTO `calendar_version` (`version`) VALUES
(1);




--
-- Struktura widoku `stats_view`
--

CREATE VIEW `stats_view` AS 
  select `stats`.`stat_id` AS `stat_id`,`stats`.`stat_date` AS `stat_date`,`stats`.`stat_interfaceid` AS `stat_interfaceid`,`stats`.`stat_value` AS `stat_value`,from_unixtime(`stats`.`stat_date`) AS `stat_data` 
  from `stats`;

--
-- Ograniczenia dla zrzutów tabel
--

--
-- Ograniczenia dla tabeli `interfaces`
--
ALTER TABLE `interfaces`
  ADD CONSTRAINT `interfaces_ibfk_1` FOREIGN KEY (`interface_deviceid`) REFERENCES `devices` (`device_id`);

--
-- Ograniczenia dla tabeli `stats`
--
ALTER TABLE `stats`
  ADD CONSTRAINT `stats_ibfk_1` FOREIGN KEY (`stat_interfaceid`) REFERENCES `interfaces` (`interface_id`);

--
-- Ograniczenia dla tabeli `timers`
--
ALTER TABLE `timers`
  ADD CONSTRAINT `timers_ibfk_1` FOREIGN KEY (`timer_interfaceidif`) REFERENCES `interfaces` (`interface_id`),
  ADD CONSTRAINT `timers_ibfk_2` FOREIGN KEY (`timer_interfaceidthen`) REFERENCES `interfaces` (`interface_id`);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
