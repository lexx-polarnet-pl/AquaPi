-- MySQL dump 10.13  Distrib 5.5.31, for debian-linux-gnu (armv7l)
--
-- Host: localhost    Database: aquapi
-- ------------------------------------------------------
-- Server version	5.5.31-0+wheezy1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `devices`
--

DROP TABLE IF EXISTS `devices`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `devices` (
  `id` int(5) NOT NULL AUTO_INCREMENT,
  `device` char(10) COLLATE utf8_polish_ci NOT NULL,
  `output` char(10) COLLATE utf8_polish_ci NOT NULL,
  `fname` char(40) COLLATE utf8_polish_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COLLATE=utf8_polish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `devices`
--

LOCK TABLES `devices` WRITE;
/*!40000 ALTER TABLE `devices` DISABLE KEYS */;
INSERT INTO `devices` VALUES (1,'light','gpio4','Oswietlenie'),
(4,'heater','gpio1','Grzalka'),(5,'cooling','gpio5','Chlodzenie'),
(6,'uni1','gpio6','Uniwersalne 1'),(7,'uni2','dummy','Uniwersalne 2'),
(8,'uni3','disabled','Uniwersalne 3'),(9,'uni4','disabled','Uniwersalne 4'),
(10,'uni5','disabled','Uniwersalne 5'),(11,'uni6','disabled','Uniwersalne 6'),
(12,'uni7','disabled','Uniwersalne 7'),(13,'uni8','disabled','Uniwersalne 8'),
(14,'uni9','disabled','Uniwersalne 9'),(15,'uni10','disabled','Uniwersalne 10'),
(16,'uni11','disabled','Uniwersalne 11'),(17,'uni12','disabled','Uniwersalne 12'),
(18,'uni13','disabled','Uniwersalne 13'),(19,'uni14','disabled','Uniwersalne 14'),
(20,'uni15','disabled','Uniwersalne 15'),(21,'uni16','disabled','Uniwersalne 16'),
(22,'uni17','disabled','Uniwersalne 17'),(23,'uni18','disabled','Uniwersalne 18'),
(24,'uni19','disabled','Uniwersalne 19'),(25,'uni20','disabled','Uniwersalne 20');
/*!40000 ALTER TABLE `devices` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `log`
--

DROP TABLE IF EXISTS `log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `log` (
  `id` int(5) NOT NULL AUTO_INCREMENT,
  `time` int(5) NOT NULL,
  `level` int(5) NOT NULL,
  `message` char(200) COLLATE utf8_polish_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COLLATE=utf8_polish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `output_stats`
--

DROP TABLE IF EXISTS `output_stats`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `output_stats` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `time_st` int(11) DEFAULT NULL,
  `event` char(10) COLLATE utf8_polish_ci DEFAULT NULL,
  `state` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COLLATE=utf8_polish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Struktura tabeli dla tabeli `relayboard`
--

CREATE TABLE IF NOT EXISTS `relayboard` (
  `relay_id` int(5) NOT NULL AUTO_INCREMENT,
  `relay_name` varchar(30) COLLATE utf8_polish_ci NOT NULL,
  `relay_type` tinyint(4) NOT NULL COMMENT '0-NO,1-NC',
  `relay_state` tinyint(4) NOT NULL DEFAULT '0',
  PRIMARY KEY (`relay_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_polish_ci AUTO_INCREMENT=9 ;

--
-- Zrzut danych tabeli `relayboard`
--

INSERT INTO `relayboard` (`relay_id`, `relay_name`, `relay_type`, `relay_state`) VALUES
(1, 'nr1', 0, 0),
(2, 'nr2', 0, 0),
(3, 'nr3', 0, 0),
(4, 'nr4', 0, 0),
(5, 'nr5', 1, 0),
(6, 'nr6', 1, 0),
(7, 'nr7', 1, 0),
(8, 'nr8', 1, 0);


--
-- Table structure for table `settings`
--

DROP TABLE IF EXISTS `settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `settings` (
  `id` int(5) NOT NULL AUTO_INCREMENT,
  `key` char(20) COLLATE utf8_polish_ci NOT NULL,
  `value` char(60) COLLATE utf8_polish_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COLLATE=utf8_polish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;


--
-- Struktura tabeli dla tabeli `sensors`
--

CREATE TABLE IF NOT EXISTS `sensors` (
  `sensor_id` int(5) NOT NULL AUTO_INCREMENT,
  `sensor_address` varchar(30) COLLATE utf8_polish_ci NOT NULL,
  `sensor_name` varchar(30) COLLATE utf8_polish_ci NOT NULL,
  `sensor_type` tinyint(4) NOT NULL DEFAULT '1' COMMENT '0-temp zadana,1-1wire temp,',
  `sensor_corr` varchar(6) COLLATE utf8_polish_ci NOT NULL DEFAULT '0' COMMENT 'korekta wartosci sensora',
  `sensor_warn_min` varchar(6) COLLATE utf8_polish_ci NOT NULL,
  `sensor_warn_max` varchar(6) COLLATE utf8_polish_ci NOT NULL,
  PRIMARY KEY (`sensor_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_polish_ci AUTO_INCREMENT=1 ;

--
-- Zrzut danych tabeli `sensors`
--

INSERT INTO `sensors` (`sensor_id`, `sensor_address`, `sensor_name`, `sensor_type`, `sensor_corr`, `sensor_warn_min`, `sensor_warn_max`) VALUES
(0, 'none', 'Temperatura zadana', 0, '0', '', '');

ALTER TABLE  `sensors` ADD  `sensor_deleted` TINYINT NOT NULL DEFAULT  '0' COMMENT  'czy czujnik jest skasowany';


--
-- Dumping data for table `settings`
--

LOCK TABLES `settings` WRITE;
/*!40000 ALTER TABLE `settings` DISABLE KEYS */;
INSERT INTO `settings` VALUES (1,'temp_day','25.0'),(2,'temp_night','24.2'),(3,'hysteresis','0.2'),
(4,'day_start','32400'),(5,'day_stop','75600'),(8,'temp_sensor','28-000000000000'),
(9,'temp_cool','26.0'),(10,'temp_sensor2','none'),(11,'temp_sensor3','none'),
(12,'temp_sensor4','none');
/*!40000 ALTER TABLE `settings` ENABLE KEYS */;
INSERT INTO `settings` (`id`, `key`, `value`) VALUES (NULL, 'temp_sensor_corr', '0');
INSERT INTO `settings` (`id`, `key`, `value`) VALUES (NULL, 'temp_sensor2_corr', '-0');
INSERT INTO `settings` (`id`, `key`, `value`) VALUES (NULL, 'temp_sensor3_corr', '0');
INSERT INTO `settings` (`id`, `key`, `value`) VALUES (NULL, 'temp_sensor4_corr', '-0');
UNLOCK TABLES;

--
-- Table structure for table `temp_stats`
--

DROP TABLE IF EXISTS `temp_stats`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `temp_stats` (
  `id` int(5) NOT NULL AUTO_INCREMENT,
  `time_st` int(5) NOT NULL,
  `sensor_id` int(5) NOT NULL,
  `temp` float NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=132251 DEFAULT CHARSET=utf8 COLLATE=utf8_polish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `timers`
--

DROP TABLE IF EXISTS `timers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `timers` (
  `id` int(5) NOT NULL AUTO_INCREMENT,
  `t_start` int(5) NOT NULL,
  `t_stop` int(5) NOT NULL,
  `line` int(5) NOT NULL,
  `device` char(10) COLLATE utf8_polish_ci DEFAULT NULL,
  `day_of_week` int(5) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8 COLLATE=utf8_polish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2013-11-05 20:52:09
