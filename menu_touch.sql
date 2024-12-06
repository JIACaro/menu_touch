-- MySQL dump 10.13  Distrib 8.0.40, for Win64 (x86_64)
--
-- Host: localhost    Database: menu_touch_db
-- ------------------------------------------------------
-- Server version	8.0.40

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
-- Table structure for table `auth_group`
--

DROP TABLE IF EXISTS `auth_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_group` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(150) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group`
--

LOCK TABLES `auth_group` WRITE;
/*!40000 ALTER TABLE `auth_group` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_group_permissions`
--

DROP TABLE IF EXISTS `auth_group_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_group_permissions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `group_id` int NOT NULL,
  `permission_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_group_permissions_group_id_permission_id_0cd325b0_uniq` (`group_id`,`permission_id`),
  KEY `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` (`permission_id`),
  CONSTRAINT `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `auth_group_permissions_group_id_b120cbf9_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group_permissions`
--

LOCK TABLES `auth_group_permissions` WRITE;
/*!40000 ALTER TABLE `auth_group_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_group_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_permission`
--

DROP TABLE IF EXISTS `auth_permission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_permission` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `content_type_id` int NOT NULL,
  `codename` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_permission_content_type_id_codename_01ab375a_uniq` (`content_type_id`,`codename`),
  CONSTRAINT `auth_permission_content_type_id_2f476e4b_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=45 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_permission`
--

LOCK TABLES `auth_permission` WRITE;
/*!40000 ALTER TABLE `auth_permission` DISABLE KEYS */;
INSERT INTO `auth_permission` VALUES (1,'Can add log entry',1,'add_logentry'),(2,'Can change log entry',1,'change_logentry'),(3,'Can delete log entry',1,'delete_logentry'),(4,'Can view log entry',1,'view_logentry'),(5,'Can add permission',2,'add_permission'),(6,'Can change permission',2,'change_permission'),(7,'Can delete permission',2,'delete_permission'),(8,'Can view permission',2,'view_permission'),(9,'Can add group',3,'add_group'),(10,'Can change group',3,'change_group'),(11,'Can delete group',3,'delete_group'),(12,'Can view group',3,'view_group'),(13,'Can add user',4,'add_user'),(14,'Can change user',4,'change_user'),(15,'Can delete user',4,'delete_user'),(16,'Can view user',4,'view_user'),(17,'Can add content type',5,'add_contenttype'),(18,'Can change content type',5,'change_contenttype'),(19,'Can delete content type',5,'delete_contenttype'),(20,'Can view content type',5,'view_contenttype'),(21,'Can add session',6,'add_session'),(22,'Can change session',6,'change_session'),(23,'Can delete session',6,'delete_session'),(24,'Can view session',6,'view_session'),(25,'Can add producto',7,'add_producto'),(26,'Can change producto',7,'change_producto'),(27,'Can delete producto',7,'delete_producto'),(28,'Can view producto',7,'view_producto'),(29,'Can add pedido',8,'add_pedido'),(30,'Can change pedido',8,'change_pedido'),(31,'Can delete pedido',8,'delete_pedido'),(32,'Can view pedido',8,'view_pedido'),(33,'Can add perfil usuario',9,'add_perfilusuario'),(34,'Can change perfil usuario',9,'change_perfilusuario'),(35,'Can delete perfil usuario',9,'delete_perfilusuario'),(36,'Can view perfil usuario',9,'view_perfilusuario'),(37,'Can add pedido producto',10,'add_pedidoproducto'),(38,'Can change pedido producto',10,'change_pedidoproducto'),(39,'Can delete pedido producto',10,'delete_pedidoproducto'),(40,'Can view pedido producto',10,'view_pedidoproducto'),(41,'Can add boleta',11,'add_boleta'),(42,'Can change boleta',11,'change_boleta'),(43,'Can delete boleta',11,'delete_boleta'),(44,'Can view boleta',11,'view_boleta');
/*!40000 ALTER TABLE `auth_permission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_user`
--

DROP TABLE IF EXISTS `auth_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_user` (
  `id` int NOT NULL AUTO_INCREMENT,
  `password` varchar(128) NOT NULL,
  `last_login` datetime(6) DEFAULT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `username` varchar(150) NOT NULL,
  `first_name` varchar(150) NOT NULL,
  `last_name` varchar(150) NOT NULL,
  `email` varchar(254) NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `date_joined` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user`
--

LOCK TABLES `auth_user` WRITE;
/*!40000 ALTER TABLE `auth_user` DISABLE KEYS */;
INSERT INTO `auth_user` VALUES (1,'pbkdf2_sha256$720000$szNq7U3rHncz0mQ2F2wtAh$rfoYT052kevdp9jtjSQe36gN3El58m59KprZ0U1hjTg=','2024-11-21 21:49:59.591822',1,'jose','','','',1,1,'2024-11-19 00:45:19.749434'),(2,'pbkdf2_sha256$720000$rpMvOU8oM2KCpbw3mQuWca$yS6+OZTwBI8dnYZvV36k0gtAblsooxh0cNDbDIrTQkg=','2024-11-21 21:52:39.997100',0,'mesa1','','','',0,1,'2024-11-19 01:06:10.239288'),(3,'pbkdf2_sha256$720000$6hH7xJN3SXxKppxSbsvtFm$39I5h2d0htr+1xY3AXICYyi2UDVerCR9YYBaJDcoFxk=','2024-11-21 21:51:55.730237',0,'cocina','','','',0,1,'2024-11-19 01:06:10.552458'),(4,'pbkdf2_sha256$720000$YUrvU46fJvsN2HvucT6Jow$VnDDe42Fnej5xY+VRQydXGHBgiNGDWGStvsX4R1kACA=','2024-11-21 21:49:17.812646',0,'garzon','','','',0,1,'2024-11-19 01:06:10.878191'),(8,'pbkdf2_sha256$720000$MXdnDIUXr6re1wWS1i2374$O/9qlcDDGZOMpQhcjhnrW0HlMQPsa2SGDNqZFa402kc=','2024-11-19 23:24:48.741224',0,'mesa2','','','',0,1,'2024-11-19 01:09:55.903354'),(11,'pbkdf2_sha256$720000$IKk1OBtGJCqF4CyY2bvob0$cczomFcxSmIaUGNFJBeFVSiSVauOAWCBvsBvzof1cB0=','2024-11-20 01:13:52.372224',0,'mesa3','','','',0,1,'2024-11-19 01:14:41.035357'),(12,'pbkdf2_sha256$720000$klxILzQ1RqcgU5g8QO4sPN$SkM29Vngm4jaFtdIQXVTSrEtFlNJJqYoorZEcCWcfAw=',NULL,0,'mesa4','','','',0,1,'2024-11-19 01:14:41.350134'),(13,'pbkdf2_sha256$720000$HWZhJogC5pqMQInIIeJZSO$QfaZnaNZQatGeKbjZ9TUdQXgvTM85Y2O9etdjltMKX8=',NULL,0,'mesa5','','','',0,1,'2024-11-19 01:14:41.672240'),(14,'pbkdf2_sha256$720000$Z84B1fuyocGPahiXHFkpcA$RLAUgsEnmRCvNP/UuMk0bAheTXdm8PJbGqgWp6PaRLo=',NULL,0,'mesa6','','','',0,1,'2024-11-19 01:14:41.986453'),(15,'pbkdf2_sha256$720000$yEI2ClQ51ziKepe3ZIGrn5$/8+kUM2ie5/18vtTHE+ChsSAbean0zm/GZUse8+MLvY=',NULL,0,'mesa7','','','',0,1,'2024-11-19 01:14:42.301808'),(16,'pbkdf2_sha256$720000$VHwW5Ax8fvXsEbfJJyxT7T$VxJoFCly1lb8SGmKs2KVldjLdOYVpoNS5w3WrhfnS2M=',NULL,0,'mesa8','','','',0,1,'2024-11-19 01:14:42.614267'),(17,'pbkdf2_sha256$720000$mlLyJ5FXXhEAYdRHIn9No9$keRP3KwDGnYQzyGovG5ZAIg4fYZHLQTUCv6m2tZMtzY=',NULL,0,'mesa9','','','',0,1,'2024-11-19 01:14:42.929302'),(18,'pbkdf2_sha256$720000$QKzoNYoT9PEoLWeyFSqN1Q$tQ3OCLoZHF4q6nijpXBY2aiQFYmACGeiWJT36UTPBfY=',NULL,0,'mesa10','','','',0,1,'2024-11-19 01:14:43.242801'),(19,'pbkdf2_sha256$720000$nDPnBtLSsWB7fqfUqwI2sB$CGnW/sWGxIm7TtzlGmwancbxpzB4WZzrMNz9Fd/EPHg=',NULL,0,'mesa11','','','',0,1,'2024-11-19 01:14:43.559066'),(20,'pbkdf2_sha256$720000$JGlMIHysCe4o8KUdfl5fHg$+zu7uK5iBNe6E/XXimZ0ZA0gubsT/Kap/slYAhIRO/I=',NULL,0,'mesa12','','','',0,1,'2024-11-19 01:14:43.873975'),(21,'pbkdf2_sha256$720000$m94Hy5HRMyMDL8CVYAwIqE$10Vm1g1D0URILlxujO/VI6eQMHrI9iO7RRbSrrUdYU4=',NULL,0,'mesa13','','','',0,1,'2024-11-19 01:14:44.189290'),(22,'pbkdf2_sha256$720000$aHdQL7gbzFJBl6fHu7KN06$6l903LPbhrDvBa3nMe7xRxGPuLPIwDvOxc2dLVYQ/84=',NULL,0,'mesa14','','','',0,1,'2024-11-19 01:14:44.503212'),(23,'pbkdf2_sha256$720000$fsu83KrJhvPqHXCRA1ru48$odUIk39KIr8kjwGnjE1y4NcuFg3aUge33PDhLJVX9A4=',NULL,0,'mesa15','','','',0,1,'2024-11-19 01:14:44.820243');
/*!40000 ALTER TABLE `auth_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_user_groups`
--

DROP TABLE IF EXISTS `auth_user_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_user_groups` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `group_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_user_groups_user_id_group_id_94350c0c_uniq` (`user_id`,`group_id`),
  KEY `auth_user_groups_group_id_97559544_fk_auth_group_id` (`group_id`),
  CONSTRAINT `auth_user_groups_group_id_97559544_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`),
  CONSTRAINT `auth_user_groups_user_id_6a12ed8b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user_groups`
--

LOCK TABLES `auth_user_groups` WRITE;
/*!40000 ALTER TABLE `auth_user_groups` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_user_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_user_user_permissions`
--

DROP TABLE IF EXISTS `auth_user_user_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_user_user_permissions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `permission_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_user_user_permissions_user_id_permission_id_14a6b632_uniq` (`user_id`,`permission_id`),
  KEY `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` (`permission_id`),
  CONSTRAINT `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user_user_permissions`
--

LOCK TABLES `auth_user_user_permissions` WRITE;
/*!40000 ALTER TABLE `auth_user_user_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_user_user_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_admin_log`
--

DROP TABLE IF EXISTS `django_admin_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_admin_log` (
  `id` int NOT NULL AUTO_INCREMENT,
  `action_time` datetime(6) NOT NULL,
  `object_id` longtext,
  `object_repr` varchar(200) NOT NULL,
  `action_flag` smallint unsigned NOT NULL,
  `change_message` longtext NOT NULL,
  `content_type_id` int DEFAULT NULL,
  `user_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `django_admin_log_content_type_id_c4bce8eb_fk_django_co` (`content_type_id`),
  KEY `django_admin_log_user_id_c564eba6_fk_auth_user_id` (`user_id`),
  CONSTRAINT `django_admin_log_content_type_id_c4bce8eb_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`),
  CONSTRAINT `django_admin_log_user_id_c564eba6_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`),
  CONSTRAINT `django_admin_log_chk_1` CHECK ((`action_flag` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_admin_log`
--

LOCK TABLES `django_admin_log` WRITE;
/*!40000 ALTER TABLE `django_admin_log` DISABLE KEYS */;
INSERT INTO `django_admin_log` VALUES (1,'2024-11-19 00:46:28.266409','1','jose - Administrador',1,'[{\"added\": {}}]',9,1),(2,'2024-11-19 01:08:14.141346','2','mesa1 - Mesa',1,'[{\"added\": {}}]',9,1),(3,'2024-11-19 01:08:23.306678','3','garzon - Garzón',1,'[{\"added\": {}}]',9,1),(4,'2024-11-19 01:09:26.144232','4','cocina - Cocina',1,'[{\"added\": {}}]',9,1),(5,'2024-11-19 01:12:11.252634','5','mesa2 - Mesa',1,'[{\"added\": {}}]',9,1),(6,'2024-11-19 01:16:18.955428','6','mesa3 - Mesa',1,'[{\"added\": {}}]',9,1),(7,'2024-11-19 01:16:31.294695','7','mesa4 - Mesa',1,'[{\"added\": {}}]',9,1),(8,'2024-11-19 01:16:35.111785','8','mesa5 - Mesa',1,'[{\"added\": {}}]',9,1),(9,'2024-11-19 01:16:39.903725','9','mesa6 - Mesa',1,'[{\"added\": {}}]',9,1),(10,'2024-11-19 01:16:44.395612','10','mesa7 - Mesa',1,'[{\"added\": {}}]',9,1),(11,'2024-11-19 01:16:48.796084','11','mesa8 - Mesa',1,'[{\"added\": {}}]',9,1),(12,'2024-11-19 01:16:53.369961','12','mesa9 - Mesa',1,'[{\"added\": {}}]',9,1),(13,'2024-11-19 01:16:57.331411','13','mesa10 - Mesa',1,'[{\"added\": {}}]',9,1),(14,'2024-11-19 01:17:00.100640','14','mesa11 - Mesa',1,'[{\"added\": {}}]',9,1),(15,'2024-11-19 01:17:02.690398','15','mesa12 - Mesa',1,'[{\"added\": {}}]',9,1),(16,'2024-11-19 01:17:06.267881','16','mesa13 - Mesa',1,'[{\"added\": {}}]',9,1),(17,'2024-11-19 01:17:09.433866','17','mesa14 - Mesa',1,'[{\"added\": {}}]',9,1),(18,'2024-11-19 01:17:12.579894','18','mesa15 - Mesa',1,'[{\"added\": {}}]',9,1),(19,'2024-11-20 06:47:17.656513','53','Boleta #53 - Total: 8900',2,'[{\"changed\": {\"fields\": [\"Pedidos\"]}}]',11,1),(20,'2024-11-20 07:00:02.890945','57','Boleta #57 - Total: 42000',2,'[{\"changed\": {\"fields\": [\"Pedidos\"]}}]',11,1);
/*!40000 ALTER TABLE `django_admin_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_content_type`
--

DROP TABLE IF EXISTS `django_content_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_content_type` (
  `id` int NOT NULL AUTO_INCREMENT,
  `app_label` varchar(100) NOT NULL,
  `model` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `django_content_type_app_label_model_76bd3d3b_uniq` (`app_label`,`model`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_content_type`
--

LOCK TABLES `django_content_type` WRITE;
/*!40000 ALTER TABLE `django_content_type` DISABLE KEYS */;
INSERT INTO `django_content_type` VALUES (1,'admin','logentry'),(3,'auth','group'),(2,'auth','permission'),(4,'auth','user'),(5,'contenttypes','contenttype'),(11,'pedidos','boleta'),(8,'pedidos','pedido'),(10,'pedidos','pedidoproducto'),(9,'pedidos','perfilusuario'),(7,'pedidos','producto'),(6,'sessions','session');
/*!40000 ALTER TABLE `django_content_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_migrations`
--

DROP TABLE IF EXISTS `django_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_migrations` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `app` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `applied` datetime(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_migrations`
--

LOCK TABLES `django_migrations` WRITE;
/*!40000 ALTER TABLE `django_migrations` DISABLE KEYS */;
INSERT INTO `django_migrations` VALUES (1,'contenttypes','0001_initial','2024-11-19 00:43:30.302766'),(2,'auth','0001_initial','2024-11-19 00:43:30.630625'),(3,'admin','0001_initial','2024-11-19 00:43:30.712201'),(4,'admin','0002_logentry_remove_auto_add','2024-11-19 00:43:30.726639'),(5,'admin','0003_logentry_add_action_flag_choices','2024-11-19 00:43:30.731041'),(6,'contenttypes','0002_remove_content_type_name','2024-11-19 00:43:30.777173'),(7,'auth','0002_alter_permission_name_max_length','2024-11-19 00:43:30.814707'),(8,'auth','0003_alter_user_email_max_length','2024-11-19 00:43:30.830839'),(9,'auth','0004_alter_user_username_opts','2024-11-19 00:43:30.834843'),(10,'auth','0005_alter_user_last_login_null','2024-11-19 00:43:30.869131'),(11,'auth','0006_require_contenttypes_0002','2024-11-19 00:43:30.870818'),(12,'auth','0007_alter_validators_add_error_messages','2024-11-19 00:43:30.876327'),(13,'auth','0008_alter_user_username_max_length','2024-11-19 00:43:30.911513'),(14,'auth','0009_alter_user_last_name_max_length','2024-11-19 00:43:30.949180'),(15,'auth','0010_alter_group_name_max_length','2024-11-19 00:43:30.961727'),(16,'auth','0011_update_proxy_permissions','2024-11-19 00:43:30.965764'),(17,'auth','0012_alter_user_first_name_max_length','2024-11-19 00:43:31.005141'),(18,'pedidos','0001_initial','2024-11-19 00:43:31.188675'),(19,'pedidos','0002_alter_pedido_estado','2024-11-19 00:43:31.201838'),(20,'pedidos','0003_alter_pedido_estado','2024-11-19 00:43:31.205870'),(21,'pedidos','0004_alter_pedido_estado','2024-11-19 00:43:31.211381'),(22,'pedidos','0005_alter_pedido_estado','2024-11-19 00:43:31.216413'),(23,'pedidos','0006_boleta','2024-11-19 00:43:31.315726'),(24,'sessions','0001_initial','2024-11-19 00:43:31.338396'),(25,'pedidos','0007_boleta_confirmada','2024-11-20 05:39:39.046837');
/*!40000 ALTER TABLE `django_migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_session`
--

DROP TABLE IF EXISTS `django_session`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_session` (
  `session_key` varchar(40) NOT NULL,
  `session_data` longtext NOT NULL,
  `expire_date` datetime(6) NOT NULL,
  PRIMARY KEY (`session_key`),
  KEY `django_session_expire_date_a5c62663` (`expire_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_session`
--

LOCK TABLES `django_session` WRITE;
/*!40000 ALTER TABLE `django_session` DISABLE KEYS */;
INSERT INTO `django_session` VALUES ('l3en82h33djzc9wh05sjh4o28wk12yic','.eJxVjDsOwjAQBe_iGln-ZOOYkj5niHa9axxAjpRPhbg7iZQC2jcz760G3NYybIvMw8jqqpy6_G6E6Sn1APzAep90muo6j6QPRZ900f3E8rqd7t9BwaXsteeQySJGY7NvgJOVxJY9IwJFA11uDcUgwi43Aki72oHxARy1XQD1-QIM0jiM:1tEF6O:S5hJsoZ6vihNhlQl_NB6eK1U1Rn3GGXdGdRkL3i3kXk','2024-12-05 21:52:40.000103'),('vwe7skg19qpqy0vte2y3l3e6xkazjqo4','.eJxVjEEOgkAMRe8yazOZGQpSl-49A2lp66AGEgZWxrsLCQvdvvf-f7uO1iV3a9G5G8RdXIzu9AuZ-qeOu5EHjffJ99O4zAP7PfGHLf42ib6uR_t3kKnkbW2aKAILNwBAZqFCC9ALMjaYhNDAajFAaVVqrFQtcnMOraZkG3afLzDeORQ:1tDZI0:Ha16Ra1TB9JK1EgCq579Q2qW9v68aMqwL8bIi3l5Slg','2024-12-04 01:13:52.375735');
/*!40000 ALTER TABLE `django_session` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pedidos_boleta`
--

DROP TABLE IF EXISTS `pedidos_boleta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pedidos_boleta` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `fecha_emision` datetime(6) NOT NULL,
  `total` int NOT NULL,
  `confirmada` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=69 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pedidos_boleta`
--

LOCK TABLES `pedidos_boleta` WRITE;
/*!40000 ALTER TABLE `pedidos_boleta` DISABLE KEYS */;
INSERT INTO `pedidos_boleta` VALUES (30,'2024-11-20 05:46:37.426149',9400,1),(31,'2024-11-20 05:48:02.489626',8400,1),(32,'2024-11-20 05:51:07.198540',8400,1),(35,'2024-11-20 05:59:25.334131',9400,1),(36,'2024-11-20 06:06:09.709981',0,1),(39,'2024-11-20 06:11:30.049888',0,1),(40,'2024-11-20 06:14:44.867976',0,1),(44,'2024-11-20 06:23:53.844653',27200,1),(45,'2024-11-20 06:27:32.512215',7600,1),(46,'2024-11-20 06:31:24.235104',6900,1),(47,'2024-11-20 06:33:50.386595',7600,1),(49,'2024-11-20 06:38:47.437561',14500,1),(51,'2024-11-20 06:42:37.075219',9400,1),(53,'2024-11-20 06:46:53.038057',8900,1),(55,'2024-11-20 06:51:51.320994',25200,1),(57,'2024-11-20 06:59:46.190352',42000,1),(59,'2024-11-20 07:01:49.379756',14500,1),(61,'2024-11-20 07:04:33.111082',10800,1),(62,'2024-11-20 07:07:13.380924',6900,1),(63,'2024-11-20 07:10:39.181421',21400,1),(65,'2024-11-20 07:13:24.050438',14300,1),(66,'2024-11-20 07:15:15.925182',45500,1),(68,'2024-11-21 21:51:07.950263',7600,1);
/*!40000 ALTER TABLE `pedidos_boleta` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pedidos_boleta_pedidos`
--

DROP TABLE IF EXISTS `pedidos_boleta_pedidos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pedidos_boleta_pedidos` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `boleta_id` bigint NOT NULL,
  `pedido_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `pedidos_boleta_pedidos_boleta_id_pedido_id_b2cbd7ea_uniq` (`boleta_id`,`pedido_id`),
  KEY `pedidos_boleta_pedidos_pedido_id_e1a15c21_fk_pedidos_pedido_id` (`pedido_id`),
  CONSTRAINT `pedidos_boleta_pedidos_boleta_id_960e1268_fk_pedidos_boleta_id` FOREIGN KEY (`boleta_id`) REFERENCES `pedidos_boleta` (`id`),
  CONSTRAINT `pedidos_boleta_pedidos_pedido_id_e1a15c21_fk_pedidos_pedido_id` FOREIGN KEY (`pedido_id`) REFERENCES `pedidos_pedido` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=86 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pedidos_boleta_pedidos`
--

LOCK TABLES `pedidos_boleta_pedidos` WRITE;
/*!40000 ALTER TABLE `pedidos_boleta_pedidos` DISABLE KEYS */;
INSERT INTO `pedidos_boleta_pedidos` VALUES (63,53,16),(68,57,22),(78,65,25),(81,66,26),(82,66,27),(85,68,36);
/*!40000 ALTER TABLE `pedidos_boleta_pedidos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pedidos_pedido`
--

DROP TABLE IF EXISTS `pedidos_pedido`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pedidos_pedido` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `fecha_pedido` datetime(6) NOT NULL,
  `total` int NOT NULL,
  `estado` varchar(6) NOT NULL,
  `mesa_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `pedidos_pedido_mesa_id_de63537a_fk_auth_user_id` (`mesa_id`),
  CONSTRAINT `pedidos_pedido_mesa_id_de63537a_fk_auth_user_id` FOREIGN KEY (`mesa_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=39 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pedidos_pedido`
--

LOCK TABLES `pedidos_pedido` WRITE;
/*!40000 ALTER TABLE `pedidos_pedido` DISABLE KEYS */;
INSERT INTO `pedidos_pedido` VALUES (1,'2024-11-19 01:38:23.788820',8900,'FIN',2),(2,'2024-11-19 01:39:13.545664',9400,'FIN',2),(3,'2024-11-19 01:41:18.150370',3500,'FIN',2),(4,'2024-11-19 01:43:20.891624',6500,'FIN',8),(5,'2024-11-19 01:56:51.668849',5900,'FIN',8),(6,'2024-11-19 01:59:25.380106',8900,'FIN',8),(7,'2024-11-19 23:24:55.637632',8400,'FIN',8),(8,'2024-11-19 23:26:01.809895',7600,'FIN',11),(9,'2024-11-19 23:26:07.278515',8400,'FIN',11),(10,'2024-11-19 23:28:21.008436',6900,'FIN',2),(11,'2024-11-20 01:13:58.305532',9400,'FIN',11),(12,'2024-11-20 04:15:03.949799',6900,'FIN',11),(13,'2024-11-20 06:15:44.251265',27200,'FIN',2),(14,'2024-11-20 06:15:51.576254',7600,'FIN',2),(15,'2024-11-20 06:34:20.451768',9400,'FIN',2),(16,'2024-11-20 06:34:26.260535',14500,'FIN',2),(17,'2024-11-20 06:34:32.000603',8900,'FIN',2),(18,'2024-11-20 06:34:38.254873',25200,'FIN',2),(19,'2024-11-20 06:54:36.299947',14500,'FIN',2),(20,'2024-11-20 06:54:42.118488',10800,'FIN',2),(21,'2024-11-20 06:54:46.583118',6900,'FIN',2),(22,'2024-11-20 06:54:52.214728',42000,'FIN',2),(23,'2024-11-20 07:09:18.613636',21400,'FIN',2),(24,'2024-11-20 07:09:28.069647',44500,'FIN',2),(25,'2024-11-20 07:09:35.409126',14300,'FIN',2),(26,'2024-11-20 07:09:43.686200',18300,'FIN',2),(27,'2024-11-20 07:14:31.264839',27200,'FIN',2),(28,'2024-11-20 18:18:58.821234',8400,'PREP',2),(29,'2024-11-20 18:29:26.926520',5900,'PREP',2),(30,'2024-11-21 15:35:01.105614',5900,'PREP',2),(31,'2024-11-21 15:40:21.476307',3500,'PREP',2),(32,'2024-11-21 16:06:38.183396',8400,'PAGAR',2),(33,'2024-11-21 16:08:28.378106',7600,'PREP',2),(34,'2024-11-21 16:24:35.371550',13800,'PAGAR',2),(35,'2024-11-21 16:40:03.128815',4900,'PREP',2),(36,'2024-11-21 16:42:09.290797',7600,'FIN',2),(37,'2024-11-21 21:52:45.946348',8400,'PREP',2),(38,'2024-11-21 21:52:58.718132',7600,'PAGAR',2);
/*!40000 ALTER TABLE `pedidos_pedido` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pedidos_pedidoproducto`
--

DROP TABLE IF EXISTS `pedidos_pedidoproducto`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pedidos_pedidoproducto` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `cantidad` int unsigned NOT NULL,
  `subtotal` int NOT NULL,
  `pedido_id` bigint NOT NULL,
  `producto_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `pedidos_pedidoproducto_pedido_id_38d5eb3e_fk_pedidos_pedido_id` (`pedido_id`),
  KEY `pedidos_pedidoproduc_producto_id_6c4daeab_fk_pedidos_p` (`producto_id`),
  CONSTRAINT `pedidos_pedidoproduc_producto_id_6c4daeab_fk_pedidos_p` FOREIGN KEY (`producto_id`) REFERENCES `pedidos_producto` (`id`),
  CONSTRAINT `pedidos_pedidoproducto_pedido_id_38d5eb3e_fk_pedidos_pedido_id` FOREIGN KEY (`pedido_id`) REFERENCES `pedidos_pedido` (`id`),
  CONSTRAINT `pedidos_pedidoproducto_chk_1` CHECK ((`cantidad` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=55 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pedidos_pedidoproducto`
--

LOCK TABLES `pedidos_pedidoproducto` WRITE;
/*!40000 ALTER TABLE `pedidos_pedidoproducto` DISABLE KEYS */;
INSERT INTO `pedidos_pedidoproducto` VALUES (1,1,8900,1,11),(2,1,3500,2,6),(3,1,5900,2,9),(4,1,3500,3,6),(5,1,6500,4,10),(6,1,5900,5,9),(7,1,8900,6,2),(8,1,4900,7,1),(9,1,3500,7,6),(10,1,7600,8,7),(11,1,8400,9,4),(12,1,6900,10,8),(13,1,3500,11,6),(14,1,5900,11,9),(15,1,6900,12,3),(16,1,8900,13,2),(17,1,8400,13,4),(18,1,9900,13,5),(19,1,7600,14,7),(20,1,3500,15,6),(21,1,5900,15,9),(22,1,6900,16,3),(23,1,7600,16,7),(24,1,8900,17,2),(25,3,25200,18,4),(26,1,6900,19,3),(27,1,7600,19,7),(28,1,4900,20,1),(29,1,5900,20,9),(30,1,6900,21,8),(31,5,42000,22,4),(32,1,6900,23,3),(33,1,7600,23,7),(34,1,6900,23,8),(35,5,44500,24,2),(36,1,4900,25,1),(37,1,3500,25,6),(38,1,5900,25,9),(39,1,8400,26,4),(40,1,9900,26,5),(41,1,8900,27,2),(42,1,8400,27,4),(43,1,9900,27,5),(44,1,8400,28,4),(45,1,5900,29,9),(46,1,5900,30,9),(47,1,3500,31,6),(48,1,8400,32,4),(49,1,7600,33,7),(50,2,13800,34,8),(51,1,4900,35,1),(52,1,7600,36,7),(53,1,8400,37,4),(54,1,7600,38,7);
/*!40000 ALTER TABLE `pedidos_pedidoproducto` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pedidos_perfilusuario`
--

DROP TABLE IF EXISTS `pedidos_perfilusuario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pedidos_perfilusuario` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `rol` varchar(10) NOT NULL,
  `usuario_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `usuario_id` (`usuario_id`),
  CONSTRAINT `pedidos_perfilusuario_usuario_id_52fcfef0_fk_auth_user_id` FOREIGN KEY (`usuario_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pedidos_perfilusuario`
--

LOCK TABLES `pedidos_perfilusuario` WRITE;
/*!40000 ALTER TABLE `pedidos_perfilusuario` DISABLE KEYS */;
INSERT INTO `pedidos_perfilusuario` VALUES (1,'admin',1),(2,'mesa',2),(3,'garzon',4),(4,'cocina',3),(5,'mesa',8),(6,'mesa',11),(7,'mesa',12),(8,'mesa',13),(9,'mesa',14),(10,'mesa',15),(11,'mesa',16),(12,'mesa',17),(13,'mesa',18),(14,'mesa',19),(15,'mesa',20),(16,'mesa',21),(17,'mesa',22),(18,'mesa',23);
/*!40000 ALTER TABLE `pedidos_perfilusuario` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pedidos_producto`
--

DROP TABLE IF EXISTS `pedidos_producto`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pedidos_producto` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `categoria` varchar(50) NOT NULL,
  `precio` int NOT NULL,
  `descripcion` longtext,
  `disponible` tinyint(1) NOT NULL,
  `imagen` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pedidos_producto`
--

LOCK TABLES `pedidos_producto` WRITE;
/*!40000 ALTER TABLE `pedidos_producto` DISABLE KEYS */;
INSERT INTO `pedidos_producto` VALUES (1,'Gengar Drink','Bebestibles',4900,'Infusión fría de té limón, té verde, té melissa y té mariposa con limón, soda y azúcar.',1,'productos/gengar_P1LTJJu.jpg'),(2,'Fireball Burger','Platos',8900,'Pollo o carne, queso mantecoso, pimentón, cebolla morada, crema de porotos, salsa Sweet Jalapeño, salsa Roccoto, tabasco y un toque de merkén y orégano.',1,'productos/fireball_FW2b7ZT.jpeg'),(3,'Chocobo Karaage','Acompañamiento',6900,'Pollitos fritos estilo japonés decorados con cebollín, sésamo blanco y negro, bañados en dúo de salsas Mayo-Teriyaki.',1,'productos/chocobo_2qqeAUw.webp'),(4,'Burrito Great Fox','Platos',8400,'Pollo apanado, cebolla morada, lechuga, mayonesa, salsa Maxi Tomato y salsa tártara con un toque de jalapeño.',1,'productos/burrito_yOa2p57.png'),(5,'Super Macho Man','Platos',9900,'Carne, tocino, queso cheddar, palta, lechuga, pepinillos, aros de cebolla apanados, salsa de ajo.',1,'productos/burg_zEbgQjL.webp'),(6,'Planta Barrel','Bebestibles',3500,'Licor de cacao, licor de café y Amaretto combinado con Special Milk y canela.',1,'productos/PlantaBarrel_zSBp845.jpg'),(7,'Quesadilla de Pollo','Acompañamiento',7600,'Una crujiente quesadilla para compartir, acompañada de pollo.',1,'productos/chesadilla_Ej6bmPM.png'),(8,'Loaded Fries','Acompañamiento',6900,'Papas fritas, champiñones, pimentón salteado, queso mantecoso, crema ácida, cebollín y ciboulette.',1,'productos/papas_RL1fW4l.webp'),(9,'Morrigan','Bebestibles',5900,'Licor de Cassis con licor de menta, pulpa de mora, limón y soda.',1,'productos/morrigan_8MExHRo.jpg'),(10,'Mega Buster','Bebestibles',6500,'Vodka, Triple Sec, limón y Blue Curaçao, una explosión cítrica refrescante con un tono azul vibrante.',1,'productos/megabusters_8lRTWoG.jpg'),(11,'Master Sword','Platos',8900,'Doble Hamburguesa de la Casa de 75 gramos, Queso Cheddar, Salsa Master Sword, Cebolla Blanqueada, Pepinillos y Lechuga.',1,'productos/masterSword_Kl4kpDS.jpg');
/*!40000 ALTER TABLE `pedidos_producto` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-11-21 21:55:56
