-- MySQL dump 10.13  Distrib 5.5.28, for debian-linux-gnu (armv7l)
--
-- Host: localhost    Database: aquapi
-- ------------------------------------------------------
-- Server version	5.5.28-1

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

DROP TABLE IF EXISTS `devices`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `devices` (
  `id` int(5) NOT NULL AUTO_INCREMENT,
  `device` char(10) COLLATE utf8_polish_ci NOT NULL,
  `output` char(10) COLLATE utf8_polish_ci NOT NULL,
  `fname` char(40) COLLATE utf8_polish_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8 COLLATE=utf8_polish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `devices`
--

LOCK TABLES `devices` WRITE;
/*!40000 ALTER TABLE `devices` DISABLE KEYS */;
INSERT INTO `devices` VALUES (1,'light','gpio4','OA›wietlenie'),(4,'heater','gpio1','GrzaA‚ka'),(5,'cooling','gpio5','Wentylator'),(6,'uni1','gpio6','OA›wietlenie 2'),(7,'uni2','dummy','Uniwersalne 2'),(8,'uni3','disabled','Uniwersalne 3'),(9,'uni4','disabled','Uniwersalne 4'),(10,'uni5','disabled','Uniwersalne 5'),(11,'uni6','disabled','Uniwersalne 6'),(12,'uni7','disabled','Uniwersalne 7'),(13,'uni8','disabled','Uniwersalne 8'),(14,'uni9','disabled','Uniwersalne 9'),(15,'uni10','disabled','Uniwersalne 10'),(16,'uni11','disabled','Uniwersalne 11'),(17,'uni12','disabled','Uniwersalne 12'),(18,'uni13','disabled','Uniwersalne 13'),(19,'uni14','disabled','Uniwersalne 14'),(20,'uni15','disabled','Uniwersalne 15'),(21,'uni16','disabled','Uniwersalne 16'),(22,'uni17','disabled','Uniwersalne 17'),(23,'uni18','disabled','Uniwersalne 18'),(24,'uni19','disabled','Uniwersalne 19'),(25,'uni20','disabled','Uniwersalne 20');
/*!40000 ALTER TABLE `devices` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `data`
--

DROP TABLE IF EXISTS `data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `data` (
  `id` int(5) NOT NULL AUTO_INCREMENT,
  `key` char(20) COLLATE utf8_polish_ci NOT NULL,
  `value` char(60) COLLATE utf8_polish_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COLLATE=utf8_polish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `data`
--

LOCK TABLES `data` WRITE;
/*!40000 ALTER TABLE `data` DISABLE KEYS */;
INSERT INTO `data` VALUES (1,'heating','1'),(2,'temp_act','24.88'),(3,'day','1');
/*!40000 ALTER TABLE `data` ENABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=65 DEFAULT CHARSET=utf8 COLLATE=utf8_polish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

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
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8 COLLATE=utf8_polish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `settings`
--

LOCK TABLES `settings` WRITE;
/*!40000 ALTER TABLE `settings` DISABLE KEYS */;
INSERT INTO `settings` VALUES (1,'temp_day','25.0'),(2,'temp_night','24.2'),(3,'hysteresis','0.2'),(4,'day_start','32400'),(5,'day_stop','75600'),(6,'gpio5_name','Uni1'),(7,'gpio6_name','Uni2'),(8,'temp_sensor','none'),(9,'temp_cool','26.0'),(10,'temp_sensor2','none'),(11,'temp_sensor3','none'),(12,'temp_sensor4','none');
/*!40000 ALTER TABLE `settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `stat`
--

DROP TABLE IF EXISTS `stat`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `stat` (
  `id` int(5) NOT NULL AUTO_INCREMENT,
  `time_st` int(5) NOT NULL,
  `heat` int(5) NOT NULL,
  `day` int(5) NOT NULL,
  `temp_t` float NOT NULL,
  `temp_a` float NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=858 DEFAULT CHARSET=utf8 COLLATE=utf8_polish_ci;
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
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8 COLLATE=utf8_polish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

-
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
) ENGINE=InnoDB AUTO_INCREMENT=35 DEFAULT CHARSET=utf8 COLLATE=utf8_polish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

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
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8 COLLATE=utf8_polish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2012-12-19 19:27:41
