-- phpMyAdmin SQL Dump
-- version 3.4.11.1deb1
-- http://www.phpmyadmin.net
--
-- Host: storage
-- Czas wygenerowania: 17 Lis 2013, 23:39
-- Wersja serwera: 5.1.49
-- Wersja PHP: 5.4.6

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";

--
-- Baza danych: `aquapi2`
--

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `devices`
--

CREATE TABLE IF NOT EXISTS `devices` (
  `device_id` int(5) NOT NULL AUTO_INCREMENT,
  `device_name` char(40) COLLATE utf8_polish_ci NOT NULL,
  `device_disabled` tinyint(4) NOT NULL DEFAULT '0',
  `device_deleted` tinyint(4) NOT NULL DEFAULT '0',
  PRIMARY KEY (`device_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_polish_ci AUTO_INCREMENT=8 ;

--
-- Zrzut danych tabeli `devices`
--

INSERT INTO `devices` (`device_id`, `device_name`, `device_disabled`, `device_deleted`) VALUES
(0, '0', 0, 0),
(1, '1wire', 0, 0),
(4, 'gpio', 0, 0),
(5, 'pwm', 0, 0),
(6, 'relayboard', 0, 0),
(7, 'dummy', 0, 0);

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `interfaces`
--

CREATE TABLE IF NOT EXISTS `interfaces` (
  `interface_id` int(5) NOT NULL AUTO_INCREMENT,
  `interface_deviceid` int(5) NOT NULL,
  `interface_address` varchar(30) COLLATE utf8_polish_ci NOT NULL,
  `interface_name` varchar(30) COLLATE utf8_polish_ci NOT NULL,
  `interface_type` tinyint(4) NOT NULL DEFAULT '1' COMMENT '0-temp zadana,1-1wire temp,2-przekaznik',
  `interface_corr` varchar(6) COLLATE utf8_polish_ci NOT NULL DEFAULT '0' COMMENT 'korekta wartosci sensora',
  `interface_draw` tinyint(4) NOT NULL DEFAULT '1' COMMENT 'czy pokazywac czujnik na wykresie',
  `interface_conf` float DEFAULT NULL,
  `interface_disabled` tinyint(4) NOT NULL DEFAULT '0',
  `interface_deleted` tinyint(4) NOT NULL DEFAULT '0' COMMENT 'czy czujnik jest skasowany',
  PRIMARY KEY (`interface_id`),
  UNIQUE KEY `address` (`interface_address`),
  KEY `device_id` (`interface_deviceid`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_polish_ci AUTO_INCREMENT=25 ;

--
-- Zrzut danych tabeli `interfaces`
--

INSERT INTO `interfaces` (`interface_id`, `interface_deviceid`, `interface_address`, `interface_name`, `interface_type`, `interface_corr`, `interface_draw`, `interface_conf`, `interface_disabled`, `interface_deleted`) VALUES
(0, 0, 'none', 'Temperatura zadana', -1, '0', 1, NULL, 0, 0),
(11, 4, 'rpi:gpio:4', 'Oświetlenie', 2, '0', 1, NULL, 0, 0),
(12, 4, 'rpi:gpio:1', 'Grzałka', 2, '0', 1, NULL, 0, 0),
(13, 4, 'rpi:gpio:5', 'Wentylator', 2, '0', 1, NULL, 0, 0),
(14, 4, 'rpi:gpio:6', 'Oświetlenie 2', 2, '0', 1, NULL, 0, 0),
(15, 7, 'rpi:dummy:0', 'Fake1', 1, '0', 1, 27.5, 0, 0),
(16, 6, 'rb:rl:1', 'nr 1', 2, '0', 1, NULL, 0, 0),
(17, 6, 'rb:rl:2', 'nr 2', 2, '0', 1, NULL, 0, 0),
(18, 6, 'rb:rl:3', 'nr 3', 2, '0', 1, NULL, 0, 0),
(19, 6, 'rb:rl:4', 'nr 4', 2, '0', 1, NULL, 0, 0),
(20, 6, 'rb:rl:5', 'nr 5', 2, '0', 1, 1, 0, 0),
(21, 6, 'rb:rl:6', 'nr 6', 2, '0', 1, 1, 0, 0),
(22, 6, 'rb:rl:7', 'nr 7', 2, '0', 1, 1, 0, 0),
(23, 6, 'rb:rl:8', 'nr 8', 2, '0', 1, 1, 0, 0),
(24, 4, 'rpi:gpio:7', 'magistrala 1-wire', 1, '0', 0, NULL, 0, 1);

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `logs`
--

CREATE TABLE IF NOT EXISTS `logs` (
  `id` int(5) NOT NULL AUTO_INCREMENT,
  `date` int(5) NOT NULL,
  `level` int(5) NOT NULL,
  `message` char(200) COLLATE utf8_polish_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_polish_ci AUTO_INCREMENT=4122 ;

--
-- Struktura tabeli dla tabeli `settings`
--

CREATE TABLE IF NOT EXISTS `settings` (
  `setting_id` int(5) NOT NULL AUTO_INCREMENT,
  `setting_key` char(20) COLLATE utf8_polish_ci NOT NULL,
  `setting_value` char(60) COLLATE utf8_polish_ci NOT NULL,
  PRIMARY KEY (`setting_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_polish_ci AUTO_INCREMENT=24 ;

--
-- Zrzut danych tabeli `settings`
--

INSERT INTO `settings` (`setting_id`, `setting_key`, `setting_value`) VALUES
(3, 'hysteresis', '0.3'),
(23, 'demon_last_activity', '1384641643');

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `stats`
--

CREATE TABLE IF NOT EXISTS `stats` (
  `stat_id` int(11) NOT NULL AUTO_INCREMENT,
  `stat_date` int(11) DEFAULT NULL,
  `stat_interfaceid` int(5) NOT NULL,
  `stat_value` float NOT NULL,
  PRIMARY KEY (`stat_id`),
  KEY `deviceid` (`stat_interfaceid`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_polish_ci AUTO_INCREMENT=1 ;

--
-- Zastąpiona struktura widoku `stats_view`
--
CREATE TABLE IF NOT EXISTS `stats_view` (
`stat_id` int(11)
,`stat_date` int(11)
,`stat_interfaceid` int(5)
,`stat_value` float
,`stat_data` datetime
);
-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `timers`
--

CREATE TABLE IF NOT EXISTS `timers` (
  `timer_id` int(5) NOT NULL AUTO_INCREMENT,
  `timer_expressionstart` varchar(64) COLLATE utf8_polish_ci NOT NULL,
  `timer_expressionstop` varchar(64) COLLATE utf8_polish_ci NOT NULL,
  `timer_interfaceid` int(5) NOT NULL,
  `timer_days` int(5) NOT NULL DEFAULT '127',
  PRIMARY KEY (`timer_id`),
  KEY `deviceid` (`timer_interfaceid`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_polish_ci AUTO_INCREMENT=1 ;

--
-- Struktura widoku `stats_view`
--
DROP TABLE IF EXISTS `stats_view`;

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
  ADD CONSTRAINT `timers_ibfk_1` FOREIGN KEY (`timer_interfaceid`) REFERENCES `interfaces` (`interface_id`);
