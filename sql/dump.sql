-- MariaDB dump 10.19  Distrib 10.4.32-MariaDB, for Win64 (AMD64)
--
-- Host: 127.0.0.1    Database: wellbe_desafio
-- ------------------------------------------------------
-- Server version	10.4.32-MariaDB

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
-- Current Database: `wellbe_desafio`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `wellbe_desafio` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci */;

USE `wellbe_desafio`;

--
-- Table structure for table `atestado`
--

DROP TABLE IF EXISTS `atestado`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `atestado` (
  `id` int(11) NOT NULL,
  `funcionario_id` int(11) NOT NULL,
  `departamento_id` int(11) DEFAULT NULL,
  `lider_funcionario_id` int(11) DEFAULT NULL,
  `data_atestado` date NOT NULL,
  `especialidade` varchar(150) NOT NULL DEFAULT '',
  `motivo` varchar(150) NOT NULL DEFAULT '',
  `custo_afastamento` decimal(10,2) NOT NULL DEFAULT 0.00,
  PRIMARY KEY (`id`),
  KEY `funcionario_id` (`funcionario_id`),
  KEY `departamento_id` (`departamento_id`),
  KEY `lider_funcionario_id` (`lider_funcionario_id`),
  KEY `idx_data_atestado` (`data_atestado`),
  CONSTRAINT `atestado_ibfk_1` FOREIGN KEY (`funcionario_id`) REFERENCES `funcionario` (`id`),
  CONSTRAINT `atestado_ibfk_2` FOREIGN KEY (`departamento_id`) REFERENCES `departamento` (`id`),
  CONSTRAINT `atestado_ibfk_3` FOREIGN KEY (`lider_funcionario_id`) REFERENCES `funcionario` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `atestado`
--

LOCK TABLES `atestado` WRITE;
/*!40000 ALTER TABLE `atestado` DISABLE KEYS */;
INSERT INTO `atestado` VALUES (1027194,12,17,25,'2019-03-01','Otorrinolaringologia','Consulta médica',132.00),(1027197,13,10,10,'2019-02-26','Gastroenterologia','Consulta médica',93.73),(1027198,22,16,21,'2019-03-21','Gastroenterologia','Consulta médica',83.58),(1027587,14,11,10,'2019-03-07','Odontologia','Consulta odontológica',96.20),(1027589,15,3,10,'2019-03-04','','Licença gala',96.44),(1027590,17,11,16,'2019-03-08','Pediatria','Acompanhamento familiar',96.70),(1027592,18,12,16,'2019-03-11','Radiologia','Exames',96.78),(1027593,18,12,16,'2019-03-08','Radiologia','Exames',96.78),(1027601,20,15,16,'2019-03-07','','Exames',9215.00),(1027604,20,15,16,'2019-03-13','','Exames',92.15),(1027607,20,15,16,'2019-03-21','','Exames',92.15),(1027612,19,3,23,'2019-03-11','Clínica Médica','Dor/Doença',93.75),(1027618,28,16,25,'2019-03-12','Odontologia','Consulta odontológica',99.16),(1027619,27,19,25,'2019-03-13','Pediatria','Acompanhamento familiar',95.24),(1027631,14,11,10,'2019-03-13','Cabeça e Pescoço','Consulta médica',96.20),(1027641,6,5,4,'2019-03-13','Dermatologia','Consulta médica',123.00),(1027646,26,18,25,'2019-03-19','Clínica Médica','Dor/Doença',98.31),(1027764,22,16,21,'2019-03-21','Ginecologia/Obstetricia','Consulta médica',83.58),(1027767,12,17,25,'2019-03-25','Dermatologia','Consulta médica',132.00),(1027769,11,8,10,'2019-03-20','Ortopedia','Dor/Doença',310.00),(1027770,11,8,10,'2019-03-21','Outras','Exames',310.45),(1027772,14,11,10,'2019-03-22','Odontologia','Consulta odontológica',96.20),(1027773,14,11,10,'2019-03-19','Odontologia','Consulta odontológica',96.20),(1027776,23,1,23,'2019-03-12','Ortopedia','Acidente',93.75),(1027777,19,3,21,'2019-03-19','Fisioterapia','Acidente',93.75),(1030876,12,17,25,'2019-03-25','Dermatologia','Consulta médica',132.00),(1030882,20,15,16,'2019-03-20','Outras','Consulta médica',92.15),(1030893,11,8,10,'2019-03-29','Ortopedia','Consulta médica',310.00),(1030902,2,2,1,'2019-03-07','Odontologia','Consulta odontológica',205.00),(1030921,14,11,10,'2019-03-27','Exames','Exames',96.20),(1030923,12,7,10,'2019-03-25','Odontologia','Cirurgia Odontológica',94.61),(1030924,12,7,10,'2019-03-27','Outras','SUS - Pronto Socorro',94.61),(1032179,20,15,16,'2019-04-10','Obstetricia','Dor/Doença',92.15),(1032180,20,15,16,'2019-04-08','Obstetricia','Dor/Doença',92.15),(1032181,20,15,16,'2019-04-01','Obstetricia','Exame periódico',92.15),(1032191,18,12,16,'2019-04-10','Ginecologia/Obstetricia','Consulta médica',96.78),(1032228,2,2,1,'2019-04-04','Neurologia pediátrica','Acompanhamento familiar',123.00),(1032230,11,8,10,'2019-04-10','Cardiologista','Exames',310.00),(1032232,11,8,10,'2019-04-03','Fisioterapia','Exames',310.00),(1032235,11,8,10,'2019-04-11','Dermatologia','Consulta médica',123.00),(1032237,24,NULL,23,'2019-04-08','Psiquiatria','Psicologia',96.09),(1032240,18,12,16,'2019-04-08','Odontologia','Consulta odontológica',96.78),(1032241,18,12,16,'2019-04-08','','Exames',96.78),(1032256,14,14,16,'2019-04-15','Outras','Consulta médica',99.66),(1032281,11,8,10,'2019-04-16','Cardiologista','Consulta médica',310.00),(1032282,11,8,10,'2019-04-17','Cardiologista','Exames',310.00),(1032287,14,2,10,'2019-04-15','Otorrinolaringologia','Dor/Doença',96.20),(1032288,14,2,10,'2019-04-09','Odontologia','Consulta médica',96.20),(1032300,18,12,16,'2019-04-18','Exames','Exames',96.78),(1032392,28,16,25,'2019-04-23','Odontologia','Consulta odontológica',99.16),(1033085,9,7,8,'2019-04-29','Gastroenterologia','Exames',94.61),(1033172,2,2,1,'2019-04-24','Pediatria','Acompanhamento familiar',205.00),(1033413,14,NULL,16,'2019-04-25','Ortopedia','Dor/Doença',99.66),(1033416,11,9,10,'2019-04-22','Cardiologista','Consulta médica',310.00),(1033423,20,15,16,'2019-04-30','Ginecologia/Obstetricia','Consulta médica',92.15),(1033425,20,15,16,'2019-04-17','Exames','Exames',92.15),(1033427,12,7,10,'2019-04-23','Pediatria','Acompanhamento familiar',94.61),(1033428,12,7,10,'2019-04-17','','',94.61),(1036380,28,20,25,'2019-05-31','Cardiologista','Exames',0.00),(1036618,12,17,25,'2019-05-23','','',132.00),(1036620,20,15,16,'2019-05-22','','',92.15),(1036621,3,3,1,'2019-05-21','','',321.00),(1036659,19,13,16,'2019-05-22','Ortopedia','Consulta médica',97.59),(1036728,25,1,25,'2019-05-28','Exames','Exames',132.00),(1036729,10,1,10,'2019-05-27','Cardiologista','Consulta médica',310.00),(1036730,11,8,10,'2019-05-23','Cardiologista','Exames',310.00),(1036733,9,7,8,'2019-05-27','','',94.61),(1036734,14,2,10,'2019-05-16','Odontologia','Consulta odontológica',96.20),(1036735,14,2,10,'2019-05-20','Otorrinolaringologia','Consulta médica',96.20),(1036736,14,2,10,'2019-05-22','','Consulta médica',96.20),(1036737,14,2,10,'2019-05-27','Odontologia','Consulta odontológica',96.20),(1036738,14,2,10,'2019-05-07','Odontologia','Cirurgia Odontológica',96.20),(1036739,2,2,1,'2019-05-06','','Consulta médica',22.00),(1036740,2,2,1,'2019-05-16','Exames','Exames',0.00),(1036741,2,2,1,'2019-05-17','','Consulta médica',22.80),(1036742,2,2,1,'2019-05-23','Neurologia pediátrica','Acompanhamento familiar',23.00),(1036743,1,1,1,'2019-05-29','Exames','Exames',20.40),(1036749,4,1,4,'2019-05-02','','Consulta médica',99.80),(1036751,12,17,25,'2019-05-16','Exames','Tratamento',132.00),(1036752,20,15,16,'2019-05-15','Ginecologia/Obstetricia','Exames',92.15),(1036760,7,6,4,'2019-05-16','Neurologia','Consulta médica',92.36),(1036762,5,4,4,'2019-05-09','','',331.00),(1036781,20,15,16,'2019-05-06','Exames','Exames',92.15),(1036786,12,17,25,'2019-05-09','','Tratamento',132.00),(1036787,22,16,21,'2019-05-10','Otorrinolaringologia','Consulta médica',83.58),(1037601,16,1,16,'2019-06-11','Odontologia','Consulta odontológica',96.56),(1037656,8,1,8,'2019-06-18','Nutrólogo','Consulta médica',94.61),(1037659,27,19,25,'2019-06-04','Oftalmologia','Acompanhamento familiar',95.24),(1037661,21,1,21,'2019-06-04','Dermatologia','Cirurgia',83.58),(1037708,19,13,16,'2019-06-07','Ortopedia','Consulta médica',97.59);
/*!40000 ALTER TABLE `atestado` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `departamento`
--

DROP TABLE IF EXISTS `departamento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `departamento` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` varchar(150) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nome` (`nome`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `departamento`
--

LOCK TABLES `departamento` WRITE;
/*!40000 ALTER TABLE `departamento` DISABLE KEYS */;
INSERT INTO `departamento` VALUES (15,'ANALISTA CONTABIL II'),(5,'ANALISTA CONTROLE OPERACIONAL I'),(16,'ANALISTA ESTUDOS E COTACAO I'),(12,'ANALISTA ESTUDOS E COTACAO II'),(17,'ANALISTA ESTUDOS E COTACAO III'),(8,'ANALISTA INFORMACOES GERENCIAIS II'),(13,'ANALISTA RISCOS II'),(19,'ANALISTA SINISTROS I'),(11,'ASSISTENTE CONTROLE OPERACIONAL'),(2,'ASSISTENTE DE IMPLANTACAO'),(10,'ASSISTENTE OPERACIONAL I'),(6,'ASSISTENTE OPERACIONAL II'),(20,'AUDITOR II'),(1,'Gerente'),(18,'TECNICO CADASTRO I'),(14,'TECNICO DE SEGUROS I'),(9,'TECNICO SEGUROS I'),(4,'TECNICO SEGUROS II'),(3,'TECNICO SEGUROS IV'),(7,'TECNICO SEGUROS VG I');
/*!40000 ALTER TABLE `departamento` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `funcionario`
--

DROP TABLE IF EXISTS `funcionario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `funcionario` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` varchar(150) NOT NULL,
  `identificacao` varchar(100) NOT NULL DEFAULT '',
  `eh_lider` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nome` (`nome`)
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `funcionario`
--

LOCK TABLES `funcionario` WRITE;
/*!40000 ALTER TABLE `funcionario` DISABLE KEYS */;
INSERT INTO `funcionario` VALUES (1,'Anonimo 101','',1),(2,'Anonimo 1','',0),(3,'Anonimo 2','',0),(4,'Anonimo 114','',1),(5,'Anonimo 3','',0),(6,'Anonimo 4','',0),(7,'Anonimo 5','',0),(8,'Anonimo 109','',1),(9,'Anonimo 9','',0),(10,'Anonimo 108','',1),(11,'Anonimo 8','',0),(12,'Anonimo 19','',0),(13,'Anonimo 10','',0),(14,'Anonimo 12','',0),(15,'Anonimo 222','',0),(16,'Anonimo 111','',1),(17,'Anonimo 61','',0),(18,'Anonimo 32','',0),(19,'Anonimo 17','',0),(20,'Anonimo 15','',0),(21,'Anonimo 116','',1),(22,'Anonimo 16','',0),(23,'Anonimo 117','',1),(24,'Anonimo 18','',0),(25,'Anonimo 119','',1),(26,'Anonimo 20','',0),(27,'Anonimo 21','',0),(28,'Anonimo 22','',0);
/*!40000 ALTER TABLE `funcionario` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-09-10 16:31:33
