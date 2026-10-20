-- MySQL dump 10.13  Distrib 8.0.46, for Win64 (x86_64)
--
-- Host: localhost    Database: queuewise
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
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

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

-- Dump completed on 2026-10-20 23:23:15
