-- MySQL dump 10.13  Distrib 8.0.46, for Win64 (x86_64)
--
-- Host: localhost    Database: queuewise_test
-- ------------------------------------------------------
-- Server version	8.0.46

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `counter_schedules`
--

DROP TABLE IF EXISTS `counter_schedules`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `counter_schedules` (
  `schedule_id` int NOT NULL AUTO_INCREMENT,
  `counter_id` int NOT NULL,
  `day_of_week` tinyint NOT NULL,
  `opens_at` time DEFAULT NULL,
  `closes_at` time DEFAULT NULL,
  `is_closed` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`schedule_id`),
  UNIQUE KEY `counter_id` (`counter_id`,`day_of_week`),
  CONSTRAINT `counter_schedules_ibfk_1` FOREIGN KEY (`counter_id`) REFERENCES `service_counters` (`counter_id`),
  CONSTRAINT `counter_schedules_chk_1` CHECK ((`day_of_week` between 1 and 7))
) ENGINE=InnoDB AUTO_INCREMENT=74 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `counter_schedules`
--

LOCK TABLES `counter_schedules` WRITE;
/*!40000 ALTER TABLE `counter_schedules` DISABLE KEYS */;
INSERT INTO `counter_schedules` VALUES (1,1,1,'09:00:00','17:00:00',0),(2,1,2,'09:00:00','17:00:00',0),(3,1,3,'09:00:00','17:00:00',0),(4,1,4,'09:00:00','17:00:00',0),(5,1,5,'09:00:00','17:00:00',0),(6,1,6,'09:00:00','13:00:00',0),(7,2,1,'09:00:00','17:00:00',0),(8,3,1,'09:30:00','16:30:00',0),(9,5,1,'09:00:00','17:00:00',0),(10,8,1,'09:00:00','17:00:00',0),(11,1,7,NULL,NULL,1),(12,5,7,NULL,NULL,1),(13,5,6,'09:00:00','13:00:00',0),(14,5,5,'09:00:00','17:00:00',0),(15,5,4,'09:00:00','17:00:00',0),(16,5,3,'09:00:00','17:00:00',0),(17,5,2,'09:00:00','17:00:00',0),(18,8,7,NULL,NULL,1),(19,8,6,'09:00:00','13:00:00',0),(20,8,5,'09:00:00','17:00:00',0),(21,8,4,'09:00:00','17:00:00',0),(22,8,3,'09:00:00','17:00:00',0),(23,8,2,'09:00:00','17:00:00',0),(24,2,7,NULL,NULL,1),(25,2,6,'09:00:00','13:00:00',0),(26,2,5,'09:00:00','17:00:00',0),(27,2,4,'09:00:00','17:00:00',0),(28,2,3,'09:00:00','17:00:00',0),(29,2,2,'09:00:00','17:00:00',0),(30,6,7,NULL,NULL,1),(31,6,6,'09:00:00','13:00:00',0),(32,6,5,'09:00:00','17:00:00',0),(33,6,4,'09:00:00','17:00:00',0),(34,6,3,'09:00:00','17:00:00',0),(35,6,2,'09:00:00','17:00:00',0),(36,6,1,'09:00:00','17:00:00',0),(37,3,7,NULL,NULL,1),(38,3,6,'09:00:00','13:00:00',0),(39,3,5,'09:00:00','17:00:00',0),(40,3,4,'09:00:00','17:00:00',0),(41,3,3,'09:00:00','17:00:00',0),(42,3,2,'09:00:00','17:00:00',0),(43,9,7,NULL,NULL,1),(44,9,6,'09:00:00','13:00:00',0),(45,9,5,'09:00:00','17:00:00',0),(46,9,4,'09:00:00','17:00:00',0),(47,9,3,'09:00:00','17:00:00',0),(48,9,2,'09:00:00','17:00:00',0),(49,9,1,'09:00:00','17:00:00',0),(50,4,7,NULL,NULL,1),(51,4,6,'09:00:00','13:00:00',0),(52,4,5,'09:00:00','17:00:00',0),(53,4,4,'09:00:00','17:00:00',0),(54,4,3,'09:00:00','17:00:00',0),(55,4,2,'09:00:00','17:00:00',0),(56,4,1,'09:00:00','17:00:00',0),(57,7,7,NULL,NULL,1),(58,7,6,'09:00:00','13:00:00',0),(59,7,5,'09:00:00','17:00:00',0),(60,7,4,'09:00:00','17:00:00',0),(61,7,3,'09:00:00','17:00:00',0),(62,7,2,'09:00:00','17:00:00',0),(63,7,1,'09:00:00','17:00:00',0),(64,10,7,NULL,NULL,1),(65,10,6,'09:00:00','13:00:00',0),(66,10,5,'09:00:00','17:00:00',0),(67,10,4,'09:00:00','17:00:00',0),(68,10,3,'09:00:00','17:00:00',0),(69,10,2,'09:00:00','17:00:00',0),(70,10,1,'09:00:00','17:00:00',0);
/*!40000 ALTER TABLE `counter_schedules` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `feedback`
--

DROP TABLE IF EXISTS `feedback`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `feedback` (
  `feedback_id` int NOT NULL AUTO_INCREMENT,
  `ticket_id` int NOT NULL,
  `customer_id` int DEFAULT NULL,
  `rating` tinyint unsigned NOT NULL,
  `comment` varchar(500) DEFAULT NULL,
  `submitted_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`feedback_id`),
  UNIQUE KEY `ticket_id` (`ticket_id`),
  KEY `customer_id` (`customer_id`),
  CONSTRAINT `feedback_ibfk_1` FOREIGN KEY (`ticket_id`) REFERENCES `queue_tickets` (`ticket_id`) ON DELETE CASCADE,
  CONSTRAINT `feedback_ibfk_2` FOREIGN KEY (`customer_id`) REFERENCES `users` (`user_id`) ON DELETE SET NULL,
  CONSTRAINT `feedback_chk_1` CHECK ((`rating` between 1 and 5))
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `feedback`
--

LOCK TABLES `feedback` WRITE;
/*!40000 ALTER TABLE `feedback` DISABLE KEYS */;
INSERT INTO `feedback` VALUES (1,1,1,5,'Quick service and helpful staff','2026-10-20 20:36:18'),(2,2,2,4,'Transaction completed smoothly','2026-10-20 20:36:18'),(3,7,7,3,'Service was good but the wait was long','2026-10-20 20:36:18'),(4,9,9,5,'KYC process was clear and efficient','2026-10-20 20:36:18'),(5,10,10,4,'Support staff resolved my query','2026-10-20 20:36:18'),(6,12,12,2,'Had to wait longer than expected','2026-10-20 20:36:18'),(7,14,2,5,'Staff explained the account process well','2026-10-20 20:36:18'),(8,15,3,4,'Cash counter service was efficient','2026-10-20 20:36:18');
/*!40000 ALTER TABLE `feedback` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `locations`
--

DROP TABLE IF EXISTS `locations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `locations` (
  `location_id` int NOT NULL AUTO_INCREMENT,
  `location_name` varchar(100) NOT NULL,
  `address` varchar(255) DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`location_id`),
  UNIQUE KEY `location_name` (`location_name`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `locations`
--

LOCK TABLES `locations` WRITE;
/*!40000 ALTER TABLE `locations` DISABLE KEYS */;
INSERT INTO `locations` VALUES (1,'Main College Office','Main College Office',1),(2,'Academic Office','Academic Office',1),(3,'Student Services Office','Student Services Office',1);
/*!40000 ALTER TABLE `locations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `queue_events`
--

DROP TABLE IF EXISTS `queue_events`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `queue_events` (
  `event_id` int NOT NULL AUTO_INCREMENT,
  `ticket_id` int NOT NULL,
  `actor_user_id` int DEFAULT NULL,
  `event_type` enum('ISSUED','CALLED','SERVICE_STARTED','COMPLETED','SKIPPED','CANCELLED') NOT NULL,
  `event_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `details` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`event_id`),
  KEY `actor_user_id` (`actor_user_id`),
  KEY `idx_ticket_events` (`ticket_id`,`event_time`),
  CONSTRAINT `queue_events_ibfk_1` FOREIGN KEY (`ticket_id`) REFERENCES `queue_tickets` (`ticket_id`) ON DELETE CASCADE,
  CONSTRAINT `queue_events_ibfk_2` FOREIGN KEY (`actor_user_id`) REFERENCES `users` (`user_id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=47 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `queue_events`
--

LOCK TABLES `queue_events` WRITE;
/*!40000 ALTER TABLE `queue_events` DISABLE KEYS */;
INSERT INTO `queue_events` VALUES (1,1,13,'ISSUED','2026-10-20 18:36:08','Token issued'),(2,1,13,'CALLED','2026-10-20 18:46:08','Customer called'),(3,1,13,'SERVICE_STARTED','2026-10-20 18:48:08','Cash transaction started'),(4,1,13,'COMPLETED','2026-10-20 18:56:08','Cash transaction completed'),(5,2,13,'ISSUED','2026-10-20 19:01:08','Token issued'),(6,2,13,'CALLED','2026-10-20 19:11:08','Customer called'),(7,2,13,'SERVICE_STARTED','2026-10-20 19:13:08','Transaction started'),(8,2,13,'COMPLETED','2026-10-20 19:21:08','Transaction completed'),(9,3,13,'ISSUED','2026-10-20 20:16:08','Token issued'),(10,5,13,'ISSUED','2026-10-20 20:28:08','Token issued'),(11,5,13,'CALLED','2026-10-20 20:34:08','Please proceed to counter'),(12,6,13,'ISSUED','2026-10-20 19:46:08','Token issued'),(13,6,13,'CANCELLED','2026-10-20 19:51:08','Customer cancelled token'),(14,7,13,'ISSUED','2026-10-20 18:56:08','Token issued'),(15,7,13,'CALLED','2026-10-20 19:06:08','Customer called'),(16,7,13,'SERVICE_STARTED','2026-10-20 19:08:08','Account service started'),(17,7,13,'COMPLETED','2026-10-20 19:23:08','Account service completed'),(18,8,14,'ISSUED','2026-10-20 20:11:08','Token issued'),(19,8,14,'CALLED','2026-10-20 20:26:08','Customer called'),(20,8,14,'SERVICE_STARTED','2026-10-20 20:28:08','Account service in progress'),(21,9,13,'ISSUED','2026-10-20 19:16:08','Token issued'),(22,9,13,'CALLED','2026-10-20 19:26:08','Customer called'),(23,9,13,'SERVICE_STARTED','2026-10-20 19:28:08','KYC verification started'),(24,9,13,'COMPLETED','2026-10-20 19:41:08','KYC verification completed'),(25,10,13,'ISSUED','2026-10-20 19:36:08','Token issued'),(26,10,13,'CALLED','2026-10-20 19:41:08','Customer called'),(27,10,13,'SERVICE_STARTED','2026-10-20 19:42:08','Support started'),(28,10,13,'COMPLETED','2026-10-20 19:48:08','Support request resolved'),(29,11,13,'ISSUED','2026-10-20 20:29:08','Token issued'),(30,12,14,'ISSUED','2026-10-20 19:06:08','Token issued'),(31,12,14,'CALLED','2026-10-20 19:14:08','Customer called'),(32,12,14,'SERVICE_STARTED','2026-10-20 19:16:08','Cash transaction started'),(33,12,14,'COMPLETED','2026-10-20 19:24:08','Cash transaction completed'),(34,13,14,'ISSUED','2026-10-20 20:21:08','Token issued'),(35,14,14,'ISSUED','2026-10-20 19:31:08','Token issued'),(36,14,14,'CALLED','2026-10-20 19:38:08','Customer called'),(37,14,14,'SERVICE_STARTED','2026-10-20 19:40:08','Account service started'),(38,14,14,'COMPLETED','2026-10-20 19:54:08','Account service completed'),(39,15,15,'ISSUED','2026-10-20 19:26:08','Token issued'),(40,15,15,'CALLED','2026-10-20 19:34:08','Customer called'),(41,15,15,'SERVICE_STARTED','2026-10-20 19:36:08','Cash transaction started'),(42,15,15,'COMPLETED','2026-10-20 19:44:08','Cash transaction completed'),(43,16,15,'ISSUED','2026-10-20 20:27:08','Token issued'),(44,17,15,'ISSUED','2026-10-20 20:14:08','Token issued'),(45,17,15,'CALLED','2026-10-20 20:24:08','Customer called'),(46,17,15,'SERVICE_STARTED','2026-10-20 20:26:08','KYC verification in progress');
/*!40000 ALTER TABLE `queue_events` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `queue_tickets`
--

DROP TABLE IF EXISTS `queue_tickets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `queue_tickets` (
  `ticket_id` int NOT NULL AUTO_INCREMENT,
  `customer_id` int DEFAULT NULL,
  `counter_id` int NOT NULL,
  `token_date` date NOT NULL,
  `token_number` int unsigned NOT NULL,
  `token_code` varchar(30) NOT NULL,
  `status` enum('WAITING','CALLED','IN_SERVICE','COMPLETED','SKIPPED','CANCELLED') NOT NULL DEFAULT 'WAITING',
  `issued_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `called_at` datetime DEFAULT NULL,
  `service_started_at` datetime DEFAULT NULL,
  `completed_at` datetime DEFAULT NULL,
  PRIMARY KEY (`ticket_id`),
  UNIQUE KEY `token_code` (`token_code`),
  UNIQUE KEY `counter_id` (`counter_id`,`token_date`,`token_number`),
  KEY `idx_queue_status` (`counter_id`,`token_date`,`status`,`token_number`),
  KEY `idx_customer_tickets` (`customer_id`,`issued_at`),
  CONSTRAINT `queue_tickets_ibfk_1` FOREIGN KEY (`customer_id`) REFERENCES `users` (`user_id`) ON DELETE SET NULL,
  CONSTRAINT `queue_tickets_ibfk_2` FOREIGN KEY (`counter_id`) REFERENCES `service_counters` (`counter_id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `queue_tickets`
--

LOCK TABLES `queue_tickets` WRITE;
/*!40000 ALTER TABLE `queue_tickets` DISABLE KEYS */;
INSERT INTO `queue_tickets` VALUES (1,1,1,'2026-10-20',101,'BOR-C1-101','COMPLETED','2026-10-20 18:35:57','2026-10-20 18:45:57','2026-10-20 18:47:57','2026-10-20 18:55:57'),(2,2,1,'2026-10-20',102,'BOR-C1-102','COMPLETED','2026-10-20 19:00:57','2026-10-20 19:10:57','2026-10-20 19:12:57','2026-10-20 19:20:57'),(3,3,1,'2026-10-20',103,'BOR-C1-103','WAITING','2026-10-20 20:15:57',NULL,NULL,NULL),(4,4,1,'2026-10-20',104,'BOR-C1-104','WAITING','2026-10-20 20:23:57',NULL,NULL,NULL),(5,5,1,'2026-10-20',105,'BOR-C1-105','CALLED','2026-10-20 20:27:57','2026-10-20 20:33:57',NULL,NULL),(6,6,1,'2026-10-20',106,'BOR-C1-106','CANCELLED','2026-10-20 19:45:57',NULL,NULL,NULL),(7,7,2,'2026-10-20',101,'BOR-A1-101','COMPLETED','2026-10-20 18:55:57','2026-10-20 19:05:57','2026-10-20 19:07:57','2026-10-20 19:22:57'),(8,8,2,'2026-10-20',102,'BOR-A1-102','IN_SERVICE','2026-10-20 20:10:57','2026-10-20 20:25:57','2026-10-20 20:27:57',NULL),(9,9,3,'2026-10-20',101,'BOR-K1-101','COMPLETED','2026-10-20 19:15:57','2026-10-20 19:25:57','2026-10-20 19:27:57','2026-10-20 19:40:57'),(10,10,4,'2026-10-20',101,'BOR-H1-101','COMPLETED','2026-10-20 19:35:57','2026-10-20 19:40:57','2026-10-20 19:41:57','2026-10-20 19:47:57'),(11,11,4,'2026-10-20',102,'BOR-H1-102','WAITING','2026-10-20 20:28:57',NULL,NULL,NULL),(12,12,5,'2026-10-20',101,'KAN-C1-101','COMPLETED','2026-10-20 19:05:57','2026-10-20 19:13:57','2026-10-20 19:15:57','2026-10-20 19:23:57'),(13,1,5,'2026-10-20',102,'KAN-C1-102','WAITING','2026-10-20 20:20:57',NULL,NULL,NULL),(14,2,6,'2026-10-20',101,'KAN-A1-101','COMPLETED','2026-10-20 19:30:57','2026-10-20 19:37:57','2026-10-20 19:39:57','2026-10-20 19:53:57'),(15,3,8,'2026-10-20',101,'AND-C1-101','COMPLETED','2026-10-20 19:25:57','2026-10-20 19:33:57','2026-10-20 19:35:57','2026-10-20 19:43:57'),(16,4,8,'2026-10-20',102,'AND-C1-102','WAITING','2026-10-20 20:26:57',NULL,NULL,NULL),(17,5,9,'2026-10-20',101,'AND-K1-101','IN_SERVICE','2026-10-20 20:13:57','2026-10-20 20:23:57','2026-10-20 20:25:57',NULL);
/*!40000 ALTER TABLE `queue_tickets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `service_counters`
--

DROP TABLE IF EXISTS `service_counters`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `service_counters` (
  `counter_id` int NOT NULL AUTO_INCREMENT,
  `location_id` int NOT NULL,
  `service_id` int NOT NULL,
  `counter_name` varchar(100) NOT NULL,
  `counter_code` varchar(20) NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`counter_id`),
  UNIQUE KEY `counter_code` (`counter_code`),
  UNIQUE KEY `location_id` (`location_id`,`counter_name`),
  KEY `service_id` (`service_id`),
  CONSTRAINT `service_counters_ibfk_1` FOREIGN KEY (`location_id`) REFERENCES `locations` (`location_id`),
  CONSTRAINT `service_counters_ibfk_2` FOREIGN KEY (`service_id`) REFERENCES `services` (`service_id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `service_counters`
--

LOCK TABLES `service_counters` WRITE;
/*!40000 ALTER TABLE `service_counters` DISABLE KEYS */;
INSERT INTO `service_counters` VALUES (1,1,1,'Fee Payment Counter','COL-F1',1),(2,1,2,'Student Enquiry Counter','COL-E1',1),(3,1,3,'Document Verification Counter','COL-D1',1),(4,1,4,'Student Support Desk','COL-S1',1),(5,2,1,'Fee Payment Counter 2','COL-F2',1),(6,2,2,'Student Enquiry Counter 2','COL-E2',1),(7,2,4,'Student Support Desk 2','COL-S2',1),(8,3,1,'Fee Payment Counter 3','COL-F3',1),(9,3,3,'Document Verification Counter 2','COL-D2',1),(10,3,4,'Student Support Desk 3','COL-S3',1);
/*!40000 ALTER TABLE `service_counters` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `services`
--

DROP TABLE IF EXISTS `services`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `services` (
  `service_id` int NOT NULL AUTO_INCREMENT,
  `service_name` varchar(100) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `avg_service_minutes` int NOT NULL DEFAULT '5',
  PRIMARY KEY (`service_id`),
  UNIQUE KEY `service_name` (`service_name`),
  CONSTRAINT `services_chk_1` CHECK ((`avg_service_minutes` > 0))
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `services`
--

LOCK TABLES `services` WRITE;
/*!40000 ALTER TABLE `services` DISABLE KEYS */;
INSERT INTO `services` VALUES (1,'Fee Payment','College fee payment and related fee enquiries',8),(2,'Student Enquiry','General student enquiries and administrative assistance',6),(3,'Document Verification','Verification of student documents and certificates',12),(4,'Student Support','General student support and guidance',6);
/*!40000 ALTER TABLE `services` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `token_sequences`
--

DROP TABLE IF EXISTS `token_sequences`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `token_sequences` (
  `counter_id` int NOT NULL,
  `token_date` date NOT NULL,
  `last_number` int unsigned NOT NULL DEFAULT '0',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`counter_id`,`token_date`),
  CONSTRAINT `token_sequences_ibfk_1` FOREIGN KEY (`counter_id`) REFERENCES `service_counters` (`counter_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `token_sequences`
--

LOCK TABLES `token_sequences` WRITE;
/*!40000 ALTER TABLE `token_sequences` DISABLE KEYS */;
INSERT INTO `token_sequences` VALUES (1,'2026-10-20',108,'2026-10-20 15:05:32'),(2,'2026-10-20',104,'2026-10-20 15:05:32'),(3,'2026-10-20',102,'2026-10-20 15:05:32'),(4,'2026-10-20',103,'2026-10-20 15:05:32'),(5,'2026-10-20',105,'2026-10-20 15:05:32'),(6,'2026-10-20',102,'2026-10-20 15:05:32'),(7,'2026-10-20',101,'2026-10-20 15:05:32'),(8,'2026-10-20',103,'2026-10-20 15:05:32'),(9,'2026-10-20',101,'2026-10-20 15:05:32'),(10,'2026-10-20',101,'2026-10-20 15:05:32');
/*!40000 ALTER TABLE `token_sequences` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `user_id` int NOT NULL AUTO_INCREMENT,
  `full_name` varchar(100) NOT NULL,
  `email` varchar(150) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `role` enum('CUSTOMER','STAFF','ADMIN') NOT NULL DEFAULT 'CUSTOMER',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'Aarav Mehta','aarav.mehta@example.com','demo_hash_01','CUSTOMER','2026-10-20 15:05:21'),(2,'Priya Sharma','priya.sharma@example.com','demo_hash_02','CUSTOMER','2026-10-20 15:05:21'),(3,'Rohan Patil','rohan.patil@example.com','demo_hash_03','CUSTOMER','2026-10-20 15:05:21'),(4,'Sneha Desai','sneha.desai@example.com','demo_hash_04','CUSTOMER','2026-10-20 15:05:21'),(5,'Ishita Kulkarni','ishita.kulkarni@example.com','demo_hash_05','CUSTOMER','2026-10-20 15:05:21'),(6,'Vikram Shah','vikram.shah@example.com','demo_hash_06','CUSTOMER','2026-10-20 15:05:21'),(7,'Neha Joshi','neha.joshi@example.com','demo_hash_07','CUSTOMER','2026-10-20 15:05:21'),(8,'Aditya Rao','aditya.rao@example.com','demo_hash_08','CUSTOMER','2026-10-20 15:05:21'),(9,'Kavita Nair','kavita.nair@example.com','demo_hash_09','CUSTOMER','2026-10-20 15:05:21'),(10,'Rahul More','rahul.more@example.com','demo_hash_10','CUSTOMER','2026-10-20 15:05:21'),(11,'Ananya Iyer','ananya.iyer@example.com','demo_hash_11','CUSTOMER','2026-10-20 15:05:21'),(12,'Siddharth Gupta','siddharth.gupta@example.com','demo_hash_12','CUSTOMER','2026-10-20 15:05:21'),(13,'Pooja Patil','pooja.patil@example.com','demo_hash_13','STAFF','2026-10-20 15:05:21'),(14,'Amit Kulkarni','amit.kulkarni@example.com','demo_hash_14','STAFF','2026-10-20 15:05:21'),(15,'Meera Shah','meera.shah@example.com','demo_hash_15','STAFF','2026-10-20 15:05:21'),(16,'QueueWise Admin','admin@queuewise.example.com','demo_hash_16','ADMIN','2026-10-20 15:05:21');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `v_queue_status_summary`
--

DROP TABLE IF EXISTS `v_queue_status_summary`;
/*!50001 DROP VIEW IF EXISTS `v_queue_status_summary`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_queue_status_summary` AS SELECT 
 1 AS `status`,
 1 AS `total_tickets`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_queue_ticket_details`
--

DROP TABLE IF EXISTS `v_queue_ticket_details`;
/*!50001 DROP VIEW IF EXISTS `v_queue_ticket_details`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_queue_ticket_details` AS SELECT 
 1 AS `ticket_id`,
 1 AS `token_code`,
 1 AS `token_number`,
 1 AS `status`,
 1 AS `customer_name`,
 1 AS `location_name`,
 1 AS `service_name`,
 1 AS `counter_code`,
 1 AS `issued_at`*/;
SET character_set_client = @saved_cs_client;

--
-- Final view structure for view `v_queue_status_summary`
--

/*!50001 DROP VIEW IF EXISTS `v_queue_status_summary`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_queue_status_summary` AS select `queue_tickets`.`status` AS `status`,count(0) AS `total_tickets` from `queue_tickets` group by `queue_tickets`.`status` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_queue_ticket_details`
--

/*!50001 DROP VIEW IF EXISTS `v_queue_ticket_details`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_queue_ticket_details` AS select `q`.`ticket_id` AS `ticket_id`,`q`.`token_code` AS `token_code`,`q`.`token_number` AS `token_number`,`q`.`status` AS `status`,`u`.`full_name` AS `customer_name`,`l`.`location_name` AS `location_name`,`s`.`service_name` AS `service_name`,`sc`.`counter_code` AS `counter_code`,`q`.`issued_at` AS `issued_at` from ((((`queue_tickets` `q` left join `users` `u` on((`q`.`customer_id` = `u`.`user_id`))) join `service_counters` `sc` on((`q`.`counter_id` = `sc`.`counter_id`))) join `locations` `l` on((`sc`.`location_id` = `l`.`location_id`))) join `services` `s` on((`sc`.`service_id` = `s`.`service_id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-10-21 18:11:43
