-- MySQL dump 10.17  Distrib 10.3.18-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: aquapi
-- ------------------------------------------------------
-- Server version	10.3.18-MariaDB-0+deb10u1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `interfaces`
--

DROP TABLE IF EXISTS `interfaces`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `interfaces` (
  `interface_id` int(5) NOT NULL AUTO_INCREMENT,
  `interface_address` varchar(200) COLLATE utf8_polish_ci DEFAULT NULL,
  `interface_name` varchar(30) COLLATE utf8_polish_ci NOT NULL,
  `interface_type` tinyint(4) NOT NULL DEFAULT 1,
  `interface_icon` varchar(20) COLLATE utf8_polish_ci DEFAULT NULL,
  `interface_conf` float DEFAULT NULL,
  `interface_deleted` tinyint(4) NOT NULL DEFAULT 0,
  `interface_htmlcolor` varchar(6) COLLATE utf8_polish_ci DEFAULT NULL,
  `interface_uom` int(5) DEFAULT NULL,
  PRIMARY KEY (`interface_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COLLATE=utf8_polish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `interfaces`
--

LOCK TABLES `interfaces` WRITE;
/*!40000 ALTER TABLE `interfaces` DISABLE KEYS */;
INSERT INTO `interfaces` VALUES (1,'dummy:temp','Wirtualny sensor temperatury',1,'temperatura.svg',0,0,"FF0000",1);
INSERT INTO `interfaces` VALUES (2,'dummy:ph','Wirtualny sensor pH',1,'pH.svg',0,0,"0000FF",2);
INSERT INTO `interfaces` VALUES (3,'dummy:out','Wirtualny port wyjścia',2,'230v.svg',0,0,"00FF00",null);
INSERT INTO `interfaces` VALUES (4,'dummy:out','Wirtualny port wyjścia PWM',3,'led.svg',0,0,"FFFF00",null);
/*!40000 ALTER TABLE `interfaces` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `logs`
--

DROP TABLE IF EXISTS `logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `logs` (
  `log_id` int(5) NOT NULL AUTO_INCREMENT,
  `log_date` int(5) NOT NULL,
  `log_level` int(5) NOT NULL,
  `log_value` char(200) COLLATE utf8_polish_ci NOT NULL,
  PRIMARY KEY (`log_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COLLATE=utf8_polish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `settings`
--

DROP TABLE IF EXISTS `settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `settings` (
  `setting_id` int(5) NOT NULL AUTO_INCREMENT,
  `setting_key` char(30) COLLATE utf8_polish_ci NOT NULL,
  `setting_value` char(60) COLLATE utf8_polish_ci NOT NULL,
  PRIMARY KEY (`setting_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COLLATE=utf8_polish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `settings`
--

LOCK TABLES `settings` WRITE;
/*!40000 ALTER TABLE `settings` DISABLE KEYS */;
INSERT INTO `settings` VALUES (null,'log_read_time','0');
INSERT INTO `settings` VALUES (null,'db_version','2020010101');
-- ustawienia modułu OŚWIETLENIE
INSERT INTO `settings` VALUES (null,'light_pwm1','20');
INSERT INTO `settings` VALUES (null,'light_pwm2','100');
INSERT INTO `settings` VALUES (null,'light_t1','32400');
INSERT INTO `settings` VALUES (null,'light_t2','75600');
INSERT INTO `settings` VALUES (null,'light_tl','1800');
INSERT INTO `settings` VALUES (null,'light_interface','4');
-- ustawienia modułu TEMPERATURA
INSERT INTO `settings` VALUES (null,'temp_tmax','25');
INSERT INTO `settings` VALUES (null,'temp_tmin','22');
INSERT INTO `settings` VALUES (null,'temp_tminal','20');
INSERT INTO `settings` VALUES (null,'temp_tmaxal','27');
INSERT INTO `settings` VALUES (null,'temp_hc','1');
INSERT INTO `settings` VALUES (null,'temp_hg','1');
INSERT INTO `settings` VALUES (null,'temp_ncor','-1');
INSERT INTO `settings` VALUES (null,'temp_interface_heat','3');
INSERT INTO `settings` VALUES (null,'temp_interface_cool','3');
INSERT INTO `settings` VALUES (null,'temp_interface_sensor','1');
-- ustawienia modułu CO2
INSERT INTO `settings` VALUES (null,'co2_probe','2');
INSERT INTO `settings` VALUES (null,'co2_mv1','1');
INSERT INTO `settings` VALUES (null,'co2_ph1','1');
INSERT INTO `settings` VALUES (null,'co2_mv2','2');
INSERT INTO `settings` VALUES (null,'co2_ph2','2');
INSERT INTO `settings` VALUES (null,'co2_co2valve','3');
INSERT INTO `settings` VALUES (null,'co2_o2valve','3');
INSERT INTO `settings` VALUES (null,'co2_co2limit','7');
INSERT INTO `settings` VALUES (null,'co2_o2limit','6');
/*!40000 ALTER TABLE `settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `stats`
--

DROP TABLE IF EXISTS `stats`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `stats` (
  `stat_id` int(11) NOT NULL AUTO_INCREMENT,
  `stat_date` int(11) DEFAULT NULL,
  `stat_interfaceid` int(5) NOT NULL,
  `stat_value` float NOT NULL,
  PRIMARY KEY (`stat_id`),
  KEY `deviceid` (`stat_interfaceid`),
  CONSTRAINT `stats_ibfk_1` FOREIGN KEY (`stat_interfaceid`) REFERENCES `interfaces` (`interface_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COLLATE=utf8_polish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `timers`
--

DROP TABLE IF EXISTS `timers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `timers` (
  `timer_id` int(5) NOT NULL AUTO_INCREMENT,
  `timer_timeif` int(5) DEFAULT NULL,
  `timer_action` tinyint(4) NOT NULL,
  `timer_interfaceidthen` int(5) NOT NULL,
  `timer_days` varchar(7) COLLATE utf8_polish_ci NOT NULL,
  PRIMARY KEY (`timer_id`),
  KEY `timer_interfaceid2` (`timer_interfaceidthen`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COLLATE=utf8_polish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `units`
--

DROP TABLE IF EXISTS `units`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `units` (
  `unit_id` int(11) NOT NULL AUTO_INCREMENT,
  `unit_name` varchar(32) COLLATE utf8_polish_ci NOT NULL,
  PRIMARY KEY (`unit_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COLLATE=utf8_polish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `units`
--

LOCK TABLES `units` WRITE;
/*!40000 ALTER TABLE `units` DISABLE KEYS */;
INSERT INTO `units` VALUES (1,'°C'),(2,'pH'),(3,'hPa'),(4,'m/s'),(5,'mm'),(6,'s'),(7,'m'),(8,'h'),(9,'%');
/*!40000 ALTER TABLE `units` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2020-01-06 12:48:56
