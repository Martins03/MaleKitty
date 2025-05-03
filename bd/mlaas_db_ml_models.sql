-- MySQL dump 10.13  Distrib 8.0.41, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: mlaas_db
-- ------------------------------------------------------
-- Server version	8.0.41

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `ml_models`
--

DROP TABLE IF EXISTS `ml_models`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ml_models` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `algorithm` varchar(45) NOT NULL,
  `model_name` varchar(100) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `file_path` varchar(255) NOT NULL,
  `accuracy` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `ix_ml_models_id` (`id`),
  CONSTRAINT `ml_models_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ml_models`
--

LOCK TABLES `ml_models` WRITE;
/*!40000 ALTER TABLE `ml_models` DISABLE KEYS */;
INSERT INTO `ml_models` VALUES (5,1,'FNN','teste123','','models\\58fefb4c-b950-40a1-b195-6eb4f7b4b913.pkl',0),(6,1,'FNN','Afonso','FNN','models\\e126a306-b685-423a-8c31-be3490d2cd81.pkl',0),(7,1,'FNN','teste123','FNN','models\\2dd177f1-190f-4651-a4d1-e59475aeabe5.pkl',0),(8,1,'FNN','teste123','FNN','models\\ef3a170b-c42a-4feb-81d6-271765f58e0e.pkl',0),(9,1,'FNN','teste123','FNN','models\\80293b4f-05e0-4d9c-a28e-15b0d624c850.pkl',0),(10,1,'FNN','teste123','FNN','models\\b0688b8b-c570-4090-a0f3-53bd2df7ebd2.pkl',0);
/*!40000 ALTER TABLE `ml_models` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-04-23 19:54:36
