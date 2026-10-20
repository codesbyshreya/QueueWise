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
-- Dumping data for table `counter_schedules`
--

LOCK TABLES `counter_schedules` WRITE;
/*!40000 ALTER TABLE `counter_schedules` DISABLE KEYS */;
INSERT INTO `counter_schedules` VALUES (1,1,1,'09:00:00','17:00:00',0),(2,1,2,'09:00:00','17:00:00',0),(3,1,3,'09:00:00','17:00:00',0),(4,1,4,'09:00:00','17:00:00',0),(5,1,5,'09:00:00','17:00:00',0),(6,1,6,'09:00:00','13:00:00',0),(7,2,1,'09:00:00','17:00:00',0),(8,3,1,'09:30:00','16:30:00',0),(9,5,1,'09:00:00','17:00:00',0),(10,8,1,'09:00:00','17:00:00',0);
/*!40000 ALTER TABLE `counter_schedules` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `feedback`
--

LOCK TABLES `feedback` WRITE;
/*!40000 ALTER TABLE `feedback` DISABLE KEYS */;
INSERT INTO `feedback` VALUES (1,1,1,5,'Quick service and helpful staff','2026-10-20 20:36:18'),(2,2,2,4,'Transaction completed smoothly','2026-10-20 20:36:18'),(3,7,7,3,'Service was good but the wait was long','2026-10-20 20:36:18'),(4,9,9,5,'KYC process was clear and efficient','2026-10-20 20:36:18'),(5,10,10,4,'Support staff resolved my query','2026-10-20 20:36:18'),(6,12,12,2,'Had to wait longer than expected','2026-10-20 20:36:18'),(7,14,2,5,'Staff explained the account process well','2026-10-20 20:36:18'),(8,15,3,4,'Cash counter service was efficient','2026-10-20 20:36:18');
/*!40000 ALTER TABLE `feedback` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `locations`
--

LOCK TABLES `locations` WRITE;
/*!40000 ALTER TABLE `locations` DISABLE KEYS */;
INSERT INTO `locations` VALUES (1,'Borivali West Branch','SV Road, Borivali West, Mumbai',1),(2,'Kandivali East Branch','Thakur Village, Kandivali East, Mumbai',1),(3,'Andheri East Branch','MIDC, Andheri East, Mumbai',1);
/*!40000 ALTER TABLE `locations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `queue_events`
--

LOCK TABLES `queue_events` WRITE;
/*!40000 ALTER TABLE `queue_events` DISABLE KEYS */;
INSERT INTO `queue_events` VALUES (1,1,13,'ISSUED','2026-10-20 18:36:08','Token issued'),(2,1,13,'CALLED','2026-10-20 18:46:08','Customer called'),(3,1,13,'SERVICE_STARTED','2026-10-20 18:48:08','Cash transaction started'),(4,1,13,'COMPLETED','2026-10-20 18:56:08','Cash transaction completed'),(5,2,13,'ISSUED','2026-10-20 19:01:08','Token issued'),(6,2,13,'CALLED','2026-10-20 19:11:08','Customer called'),(7,2,13,'SERVICE_STARTED','2026-10-20 19:13:08','Transaction started'),(8,2,13,'COMPLETED','2026-10-20 19:21:08','Transaction completed'),(9,3,13,'ISSUED','2026-10-20 20:16:08','Token issued'),(10,5,13,'ISSUED','2026-10-20 20:28:08','Token issued'),(11,5,13,'CALLED','2026-10-20 20:34:08','Please proceed to counter'),(12,6,13,'ISSUED','2026-10-20 19:46:08','Token issued'),(13,6,13,'CANCELLED','2026-10-20 19:51:08','Customer cancelled token'),(14,7,13,'ISSUED','2026-10-20 18:56:08','Token issued'),(15,7,13,'CALLED','2026-10-20 19:06:08','Customer called'),(16,7,13,'SERVICE_STARTED','2026-10-20 19:08:08','Account service started'),(17,7,13,'COMPLETED','2026-10-20 19:23:08','Account service completed'),(18,8,14,'ISSUED','2026-10-20 20:11:08','Token issued'),(19,8,14,'CALLED','2026-10-20 20:26:08','Customer called'),(20,8,14,'SERVICE_STARTED','2026-10-20 20:28:08','Account service in progress'),(21,9,13,'ISSUED','2026-10-20 19:16:08','Token issued'),(22,9,13,'CALLED','2026-10-20 19:26:08','Customer called'),(23,9,13,'SERVICE_STARTED','2026-10-20 19:28:08','KYC verification started'),(24,9,13,'COMPLETED','2026-10-20 19:41:08','KYC verification completed'),(25,10,13,'ISSUED','2026-10-20 19:36:08','Token issued'),(26,10,13,'CALLED','2026-10-20 19:41:08','Customer called'),(27,10,13,'SERVICE_STARTED','2026-10-20 19:42:08','Support started'),(28,10,13,'COMPLETED','2026-10-20 19:48:08','Support request resolved'),(29,11,13,'ISSUED','2026-10-20 20:29:08','Token issued'),(30,12,14,'ISSUED','2026-10-20 19:06:08','Token issued'),(31,12,14,'CALLED','2026-10-20 19:14:08','Customer called'),(32,12,14,'SERVICE_STARTED','2026-10-20 19:16:08','Cash transaction started'),(33,12,14,'COMPLETED','2026-10-20 19:24:08','Cash transaction completed'),(34,13,14,'ISSUED','2026-10-20 20:21:08','Token issued'),(35,14,14,'ISSUED','2026-10-20 19:31:08','Token issued'),(36,14,14,'CALLED','2026-10-20 19:38:08','Customer called'),(37,14,14,'SERVICE_STARTED','2026-10-20 19:40:08','Account service started'),(38,14,14,'COMPLETED','2026-10-20 19:54:08','Account service completed'),(39,15,15,'ISSUED','2026-10-20 19:26:08','Token issued'),(40,15,15,'CALLED','2026-10-20 19:34:08','Customer called'),(41,15,15,'SERVICE_STARTED','2026-10-20 19:36:08','Cash transaction started'),(42,15,15,'COMPLETED','2026-10-20 19:44:08','Cash transaction completed'),(43,16,15,'ISSUED','2026-10-20 20:27:08','Token issued'),(44,17,15,'ISSUED','2026-10-20 20:14:08','Token issued'),(45,17,15,'CALLED','2026-10-20 20:24:08','Customer called'),(46,17,15,'SERVICE_STARTED','2026-10-20 20:26:08','KYC verification in progress');
/*!40000 ALTER TABLE `queue_events` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `queue_tickets`
--

LOCK TABLES `queue_tickets` WRITE;
/*!40000 ALTER TABLE `queue_tickets` DISABLE KEYS */;
INSERT INTO `queue_tickets` VALUES (1,1,1,'2026-10-20',101,'BOR-C1-101','COMPLETED','2026-10-20 18:35:57','2026-10-20 18:45:57','2026-10-20 18:47:57','2026-10-20 18:55:57'),(2,2,1,'2026-10-20',102,'BOR-C1-102','COMPLETED','2026-10-20 19:00:57','2026-10-20 19:10:57','2026-10-20 19:12:57','2026-10-20 19:20:57'),(3,3,1,'2026-10-20',103,'BOR-C1-103','WAITING','2026-10-20 20:15:57',NULL,NULL,NULL),(4,4,1,'2026-10-20',104,'BOR-C1-104','WAITING','2026-10-20 20:23:57',NULL,NULL,NULL),(5,5,1,'2026-10-20',105,'BOR-C1-105','CALLED','2026-10-20 20:27:57','2026-10-20 20:33:57',NULL,NULL),(6,6,1,'2026-10-20',106,'BOR-C1-106','CANCELLED','2026-10-20 19:45:57',NULL,NULL,NULL),(7,7,2,'2026-10-20',101,'BOR-A1-101','COMPLETED','2026-10-20 18:55:57','2026-10-20 19:05:57','2026-10-20 19:07:57','2026-10-20 19:22:57'),(8,8,2,'2026-10-20',102,'BOR-A1-102','IN_SERVICE','2026-10-20 20:10:57','2026-10-20 20:25:57','2026-10-20 20:27:57',NULL),(9,9,3,'2026-10-20',101,'BOR-K1-101','COMPLETED','2026-10-20 19:15:57','2026-10-20 19:25:57','2026-10-20 19:27:57','2026-10-20 19:40:57'),(10,10,4,'2026-10-20',101,'BOR-H1-101','COMPLETED','2026-10-20 19:35:57','2026-10-20 19:40:57','2026-10-20 19:41:57','2026-10-20 19:47:57'),(11,11,4,'2026-10-20',102,'BOR-H1-102','WAITING','2026-10-20 20:28:57',NULL,NULL,NULL),(12,12,5,'2026-10-20',101,'KAN-C1-101','COMPLETED','2026-10-20 19:05:57','2026-10-20 19:13:57','2026-10-20 19:15:57','2026-10-20 19:23:57'),(13,1,5,'2026-10-20',102,'KAN-C1-102','WAITING','2026-10-20 20:20:57',NULL,NULL,NULL),(14,2,6,'2026-10-20',101,'KAN-A1-101','COMPLETED','2026-10-20 19:30:57','2026-10-20 19:37:57','2026-10-20 19:39:57','2026-10-20 19:53:57'),(15,3,8,'2026-10-20',101,'AND-C1-101','COMPLETED','2026-10-20 19:25:57','2026-10-20 19:33:57','2026-10-20 19:35:57','2026-10-20 19:43:57'),(16,4,8,'2026-10-20',102,'AND-C1-102','WAITING','2026-10-20 20:26:57',NULL,NULL,NULL),(17,5,9,'2026-10-20',101,'AND-K1-101','IN_SERVICE','2026-10-20 20:13:57','2026-10-20 20:23:57','2026-10-20 20:25:57',NULL);
/*!40000 ALTER TABLE `queue_tickets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `service_counters`
--

LOCK TABLES `service_counters` WRITE;
/*!40000 ALTER TABLE `service_counters` DISABLE KEYS */;
INSERT INTO `service_counters` VALUES (1,1,1,'Cash Counter 1','BOR-C1',1),(2,1,2,'Account Counter 1','BOR-A1',1),(3,1,3,'KYC Counter 1','BOR-K1',1),(4,1,4,'Help Desk','BOR-H1',1),(5,2,1,'Cash Counter 1','KAN-C1',1),(6,2,2,'Account Counter 1','KAN-A1',1),(7,2,4,'Help Desk','KAN-H1',1),(8,3,1,'Cash Counter 1','AND-C1',1),(9,3,3,'KYC Counter 1','AND-K1',1),(10,3,4,'Help Desk','AND-H1',1);
/*!40000 ALTER TABLE `service_counters` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `services`
--

LOCK TABLES `services` WRITE;
/*!40000 ALTER TABLE `services` DISABLE KEYS */;
INSERT INTO `services` VALUES (1,'Cash Deposit and Withdrawal','Cash transactions and withdrawals - updated',8),(2,'Account Services','Account opening, statements and account updates',15),(3,'KYC Update','Customer identity verification and KYC updates',12),(4,'Customer Support','General banking queries and assistance',6);
/*!40000 ALTER TABLE `services` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `token_sequences`
--

LOCK TABLES `token_sequences` WRITE;
/*!40000 ALTER TABLE `token_sequences` DISABLE KEYS */;
INSERT INTO `token_sequences` VALUES (1,'2026-10-20',108,'2026-10-20 15:05:32'),(2,'2026-10-20',104,'2026-10-20 15:05:32'),(3,'2026-10-20',102,'2026-10-20 15:05:32'),(4,'2026-10-20',103,'2026-10-20 15:05:32'),(5,'2026-10-20',105,'2026-10-20 15:05:32'),(6,'2026-10-20',102,'2026-10-20 15:05:32'),(7,'2026-10-20',101,'2026-10-20 15:05:32'),(8,'2026-10-20',103,'2026-10-20 15:05:32'),(9,'2026-10-20',101,'2026-10-20 15:05:32'),(10,'2026-10-20',101,'2026-10-20 15:05:32');
/*!40000 ALTER TABLE `token_sequences` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'Aarav Mehta','aarav.mehta@example.com','demo_hash_01','CUSTOMER','2026-10-20 15:05:21'),(2,'Priya Sharma','priya.sharma@example.com','demo_hash_02','CUSTOMER','2026-10-20 15:05:21'),(3,'Rohan Patil','rohan.patil@example.com','demo_hash_03','CUSTOMER','2026-10-20 15:05:21'),(4,'Sneha Desai','sneha.desai@example.com','demo_hash_04','CUSTOMER','2026-10-20 15:05:21'),(5,'Ishita Kulkarni','ishita.kulkarni@example.com','demo_hash_05','CUSTOMER','2026-10-20 15:05:21'),(6,'Vikram Shah','vikram.shah@example.com','demo_hash_06','CUSTOMER','2026-10-20 15:05:21'),(7,'Neha Joshi','neha.joshi@example.com','demo_hash_07','CUSTOMER','2026-10-20 15:05:21'),(8,'Aditya Rao','aditya.rao@example.com','demo_hash_08','CUSTOMER','2026-10-20 15:05:21'),(9,'Kavita Nair','kavita.nair@example.com','demo_hash_09','CUSTOMER','2026-10-20 15:05:21'),(10,'Rahul More','rahul.more@example.com','demo_hash_10','CUSTOMER','2026-10-20 15:05:21'),(11,'Ananya Iyer','ananya.iyer@example.com','demo_hash_11','CUSTOMER','2026-10-20 15:05:21'),(12,'Siddharth Gupta','siddharth.gupta@example.com','demo_hash_12','CUSTOMER','2026-10-20 15:05:21'),(13,'Pooja Patil','pooja.patil@example.com','demo_hash_13','STAFF','2026-10-20 15:05:21'),(14,'Amit Kulkarni','amit.kulkarni@example.com','demo_hash_14','STAFF','2026-10-20 15:05:21'),(15,'Meera Shah','meera.shah@example.com','demo_hash_15','STAFF','2026-10-20 15:05:21'),(16,'QueueWise Admin','admin@queuewise.example.com','demo_hash_16','ADMIN','2026-10-20 15:05:21');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-10-20 23:24:03
